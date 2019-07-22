class Song < ApplicationRecord
  has_many   :artist_songs
  has_many   :artists, :through => :artist_songs
  has_many   :playlist_songs
  has_many   :playlists, :through => :playlist_songs
  belongs_to :album

  validates :name, uniqueness: true, presence: true
  validates :artist_songs, :length => { :minimum => 1 }
  scope :by_name, -> (name) { where("name LIKE ?", "%#{name}%") }
  scope :by_description, -> (description) { where("description LIKE ?", "%#{description}") }
  scope :by_created_at, -> (from, to) { where("created_at >= ? AND created_at <= ?", from, to) }
  scope :by_updated_at, -> (from, to) { where("updated_at >= ? AND updated_at <= ?", from, to) }
  scope :by_recorded_date, -> (from, to) { where("recorded_date >= ? AND recorded_date <= ?", from, to) }

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
