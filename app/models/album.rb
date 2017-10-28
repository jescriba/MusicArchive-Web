class Album < ApplicationRecord
  has_many :artist_albums
  has_many :artists, :through => :artist_albums
  has_many :songs

  validates :name, uniqueness: true, presence: true
  validates :artist_albums, :length => { :minimum => 1 }

  def artist_names
    names = ""
    self.artists.each do |artist|
      names += "#{artist.name}, "
    end

    # Remove trailing ,
    names.chomp!(", ")
    return names
  end
end
