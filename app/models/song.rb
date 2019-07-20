class Song < ApplicationRecord
  has_many   :artist_songs
  has_many   :artists, :through => :artist_songs
  has_many   :playlist_songs
  has_many   :playlists, :through => :playlist_songs
  belongs_to :album

  validates :name, uniqueness: true, presence: true
  validates :artist_songs, :length => { :minimum => 1 }

  # Song(id: integer, name: string, description: text, url: text, lossless_url: text, recorded_date: date, album_id: integer, artist_songs_id: integer, created_at: datetime, updated_at: datetime, album_track_order: integer, playlist_song_id: integer)

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
