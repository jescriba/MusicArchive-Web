class Song < ApplicationRecord
  has_many   :artists, :through => :albums
  belongs_to :album
end
