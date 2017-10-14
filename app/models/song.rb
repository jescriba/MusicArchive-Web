class Song < ApplicationRecord
  has_many   :artist_songs
  has_many   :artists, :through => :artist_songs
  belongs_to :album

  validates :name, uniqueness: true, presence: true
end
