class SongsTranscodeJob < ApplicationJob
  queue_as :default
  @queue = :song_transcode

  def perform(params)
    return unless params[:song] and params[:file_path] and params[:content_type] and params[:resource_name]
    song = params[:song]
    file_path = params[:file_path]
    content_type = params[:content_type]

    raise "Missing file path" unless File.exists? file_path

    # Tempfile to write lossy file to
    tempfile_path = "/app/tmp/temp#{song.id}.mp3"

    # Use ffmpeg to transcode to V0 mp3
    system "ffmpeg", "-loglevel", "quiet", "-i", "#{file_path}", "-codec:a", "libmp3lame", "-qscale:a", "0", "#{tempfile_path}"

    # Upload transcoded version to storage
    storage_client = StorageClient.new
    storage_client.upload({ song: song, file: File.new(tempfile_path), content_type: "audio/mp3" })

    # Delete tempfile
    FileUtils.rm(tempfile_path)

    # Save song with new url
    song.url = storage_client.url
    # TODO Handling failures?
    song.save
  end
end
