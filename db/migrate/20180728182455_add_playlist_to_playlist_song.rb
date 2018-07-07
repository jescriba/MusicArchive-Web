class AddPlaylistToPlaylistSong < ActiveRecord::Migration[5.1]
  def change
    add_reference :playlist_songs, :playlist, foreign_key: true
  end
end
