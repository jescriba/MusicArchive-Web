class AddTrackOrderToPlaylistSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :playlist_songs, :track_order, :integer
  end
end
