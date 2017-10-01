class Album < ApplicationRecord
  has_many :artist_albums
  has_many :artists, :through => :artist_albums
  has_many :songs
end
