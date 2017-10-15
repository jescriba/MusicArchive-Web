class SongsDeleteJob < ApplicationJob
  queue_as :default
  @queue = :song_delete

  def perform(params)
    return unless params[:song]
    song = params[:song]

    lossless_url = song.lossless_url
    lossy_url = song.url

    storage_client = StorageClient.new
    storage_client.delete({ url: song.lossless_url }) if song.lossless_url
    storage_client.delete({ url: song.lossy_url }) if song.lossy_url

    song.lossless_url = nil
    song.url = nil
    song.save
  end
end
