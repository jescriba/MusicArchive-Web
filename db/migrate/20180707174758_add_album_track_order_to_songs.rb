class AddAlbumTrackOrderToSongs < ActiveRecord::Migration[5.1]
  def change
    add_column :songs, :album_track_order, :integer
  end
end
