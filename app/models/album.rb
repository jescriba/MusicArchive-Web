class Album < ApplicationRecord
  has_many :artist_albums
  has_many :artists, :through => :artist_albums
  has_many :songs

  validates :name, uniqueness: true, presence: true
  validates :artist_albums, :length => { :minimum => 1 }
end
