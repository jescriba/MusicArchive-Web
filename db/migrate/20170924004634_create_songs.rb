class CreateSongs < ActiveRecord::Migration[5.1]
  def change
    create_table :songs do |t|
      t.string :name
      t.text :description
      t.text :url
      t.text :lossless_url
      t.date :recorded_date
      t.belongs_to :album, :index => true
      t.belongs_to :artist_songs, :index => true

      t.timestamps
    end
  end
end
