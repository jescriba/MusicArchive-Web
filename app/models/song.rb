class Song < ApplicationRecord
  has_many   :artists, :through => :albums
  belongs_to :album

  validates :name, uniqueness: true, presence: true
end
