class Album < ApplicationRecord
  has_many :artist_albums
  has_many :artists, :through => :artist_albums
  has_many :songs

  validates :name, uniqueness: true, presence: true
  validates :artist_albums, :length => { :minimum => 1 }
  scope :by_name, -> (name) { where("name LIKE ?", "%#{name}%") }
  scope :by_description, -> (description) { where("description LIKE ?", "%#{description}") }
  scope :by_created_at, -> (from, to) { where("created_at >= ? AND created_at <= ?", from, to) }
  scope :by_updated_at, -> (from, to) { where("updated_at >= ? AND updated_at <= ?", from, to) }
  scope :by_release_date, -> (from, to) { where("release_date >= ? AND release_date <= ?", from, to) }

  #Album(id: integer, name: string, description: text, release_date: date, created_at: datetime, updated_at: datetime)

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
