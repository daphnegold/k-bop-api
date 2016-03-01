class Song < ActiveRecord::Base
  has_many :playlists_songs
  has_many :playlists, through: :playlists_songs
  validates :uri, :presence => true, :uniqueness => true
end
