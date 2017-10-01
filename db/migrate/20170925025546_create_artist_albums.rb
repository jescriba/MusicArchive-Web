class CreateArtistAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :artist_albums do |t|
      t.belongs_to :artist, :index => true
      t.belongs_to :album, :index => true

      t.timestamps
    end
  end
end
