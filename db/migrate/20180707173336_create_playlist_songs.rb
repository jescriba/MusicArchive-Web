class CreatePlaylistSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :playlist_songs do |t|
      t.belongs_to :playlist, :index => true
      t.belongs_to :song, :index => true

      t.timestamps
    end
  end
end
