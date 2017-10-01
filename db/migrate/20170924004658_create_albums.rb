class CreateAlbums < ActiveRecord::Migration[5.1]
  def change
    create_table :albums do |t|
      t.string :name
      t.text :description
      t.date :release_date

      t.timestamps
    end
  end
end
