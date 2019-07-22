class Playlist < ApplicationRecord
  has_many :playlist_songs
  has_many :songs, :through => :playlist_songs

  validates :name, uniqueness: true, presence: true
  validates :playlist_songs, :length => { :minimum => 1}
  scope :by_name, -> (name) { where("name LIKE ?", "%#{name}%") }
  scope :by_description, -> (description) { where("description LIKE ?", "%#{description}") }
  scope :by_created_at, -> (from, to) { where("created_at >= ? AND created_at <= ?", from, to) }
  scope :by_updated_at, -> (from, to) { where("updated_at >= ? AND updated_at <= ?", from, to) }

  #Playlist(id: integer, name: string, description: text, created_at: datetime, updated_at: datetime, playlist_song_id: integer)

  after_save :save_playlist_songs
  def save_playlist_songs
    playlist_songs.each { |s| s.save }
  end

end
