class Artist < ApplicationRecord
  has_many :artist_albums
  has_many :artist_songs
  has_many :albums, :through => :artist_albums
  has_many :songs, :through => :artist_songs

  validates :name, uniqueness: true, presence: true

  after_save :add_to_default_album

  #Artist(id: integer, name: string, description: text, created_at: datetime, updated_at: datetime)

  private
  def add_to_default_album
    album = Album.first || Album.new(name: "Uncategorized")
    album.artists << self
    album.save
  end
end
