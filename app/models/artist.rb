class Artist < ApplicationRecord
  has_many :artist_albums
  has_many :albums, :through => :artist_albums
  has_many :songs, :through => :albums

  validates :name, uniqueness: true, presence: true

  after_save :add_to_default_album

  private
  def add_to_default_album
    album = Album.first || Album.new(name: "Uncategorized")
    album.save
    ArtistAlbum.create(artist_id: self.id, album_id: album.id)
  end
end
