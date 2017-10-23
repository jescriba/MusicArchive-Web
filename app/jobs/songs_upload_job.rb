class SongsUploadJob < ApplicationJob
  queue_as :default
  @queue = :song_upload

  def perform(params)
    return unless params[:song] and params[:file_path] and params[:content_type]
    song = params[:song]
    file_path = params[:file_path]
    content_type = params[:content_type]
    file = File.new file_path

    storage_client = StorageClient.new
    # S3 client resolves if it's uploading a new resource
    # Or updating an existing one
    storage_client.upload({ song: song, content_type: content_type, file: file })
    if storage_client.should_transcode?
      song.lossless_url = storage_client.lossless_url
      resource_name = storage_client.resource_name
      SongsTranscodeJob.perform_later song
      song.save
      return
    end

    song.url = storage_client.url
    # TODO Handling failures?
    song.save
  end
end
