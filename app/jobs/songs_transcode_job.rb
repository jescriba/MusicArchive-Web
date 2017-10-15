class SongsTranscodeJob < ApplicationJob
  queue_as :default
  @queue = :song_transcode

  def perform(params)
    return unless params[:song] and params[:file] and params[:content_type] and params[:resource_name]
    song = params[:song]
    file = params[:file]
    content_type = params[:content_type]

    raise "Missing file path" unless File.exists? file.path

    # Tempfile to write lossy file to
    tempfile_path = "/app/tmp/temp#{song.id}#{File.extname(file.path)}"

    # Use ffmpeg to transcode to V0 mp3
    cmd = "ffmpeg -i #{file.path} -codec:a libmp3lame -qscale:a 0 #{tempfile_path}"
    `#{cmd}`

    # Upload transcoded version to storage
    storage_client = StorageClient.new
    storage_client.upload({ song: song, file: file, content_type: "audio/mp3" })

    # Delete tempfile
    FileUtils.rm(tempfile_path)

    # Save song with new url
    song.url = storage_client.url
    # TODO Handling failures?
    song.save
  end
end
