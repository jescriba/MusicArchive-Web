class Song < ApplicationRecord
  has_many   :artist_songs
  has_many   :artists, :through => :artist_songs
  belongs_to :album

  validates :name, uniqueness: true, presence: true
  validates :artist_songs, :length => { :minimum => 1 }

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
