class Playlist < ApplicationRecord
  has_many :playlist_songs
  has_many :songs, :through => :playlist_songs

  validates :name, uniqueness: true, presence: true
  validates :playlist_songs, :length => { :minimum => 1}

  after_save :save_playlist_songs
  def save_playlist_songs
    playlist_songs.each { |s| s.save }
  end

end
