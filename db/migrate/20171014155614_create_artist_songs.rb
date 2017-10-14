class CreateArtistSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_songs do |t|
      t.belongs_to :artist, :index => true
      t.belongs_to :song, :index => true

      t.timestamps
    end
  end
end
