class AddSongToPlaylistSong < ActiveRecord::Migration[5.1]
  def change
    add_reference :playlist_songs, :song, foreign_key: true
  end
end
