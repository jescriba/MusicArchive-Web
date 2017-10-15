class SongsDeleteJob < ApplicationJob
  queue_as :default
  @queue = :song_delete

  def perform(song)
    lossless_url = song.lossless_url
    lossy_url = song.url

    storage_client = StorageClient.new
    storage_client.delete({ url: lossless_url }) if lossless_url
    storage_client.delete({ url: lossy_url }) if lossy_url
  end
end
