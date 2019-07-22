class Artist < ApplicationRecord
  has_many :artist_albums
  has_many :artist_songs
  has_many :albums, :through => :artist_albums
  has_many :songs, :through => :artist_songs

  validates :name, uniqueness: true, presence: true

  after_save :add_to_default_album
  scope :by_name, -> (name) { where("name LIKE ?", "%#{name}%") }
  scope :by_description, -> (description) { where("description LIKE ?", "%#{description}") }
  scope :by_created_at, -> (from, to) { where("created_at >= ? AND created_at <= ?", from, to) }
  scope :by_updated_at, -> (from, to) { where("updated_at >= ? AND updated_at <= ?", from, to) }
  #Artist(id: integer, name: string, description: text, created_at: datetime, updated_at: datetime)

  private
  def add_to_default_album
    album = Album.first || Album.new(name: "Uncategorized")
    album.artists << self
    album.save
  end
end
