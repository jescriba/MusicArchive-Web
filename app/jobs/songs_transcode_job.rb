class SongsTranscodeJob < ApplicationJob
  queue_as :default
  @queue = :song_transcode

  def perform(song)
    lossless_url = song.lossless_url

    # Download resource from s3 since can't predictably write/read to tmp on heroku
    extension = File.extname(lossless_url)
    tempfile_lossless_path = "/tmp/#{SecureRandom.uuid}#{extension}"
    download_cmd_str = "curl -o #{tempfile_lossless_path} #{lossless_url}"
    download_cmd =  `#{download_cmd_str}`

    # Tempfile to write lossy file to
    tempfile_path = "/tmp/temp#{song.id}.mp3"

    # Use ffmpeg to transcode to V0 mp3
    system "ffmpeg", "-loglevel", "quiet", "-i", "#{tempfile_lossless_path}", "-codec:a", "libmp3lame", "-qscale:a", "0", "#{tempfile_path}"

    # Upload transcoded version to storage
    storage_client = StorageClient.new
    storage_client.upload({ song: song, file: File.new(tempfile_path), content_type: "audio/mp3" })

    # Delete tempfiles
    FileUtils.rm tempfile_path
    FileUtils.rm tempfile_lossless_path

    # Save song with new url
    song.url = storage_client.url
    # TODO Handling failures?
    song.save
  end
end
