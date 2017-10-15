class SongsUploadJob < ApplicationJob
  queue_as :default
  @queue = :song_upload

  def perform(params)
    return unless params[:song] and params[:file] and params[:content_type]
    song = params[:song]
    file = params[:file]
    content_type = params[:content_type]

    storage_client = StorageClient.new()
    # S3 client resolves if it's uploading a new resource
    # Or updating an existing one
    storage_client.upload(params)
    if storage_client.should_transcode?
      song.lossless_url = storage_client.lossless_url
      params[:resource_name] = storage_client.resource_name
      SongsTranscodeJob.perform_now(params)
      song.save
      return
    end

    song.url = storage_client.url
    # TODO Handling failures?
    song.save
  end
end
