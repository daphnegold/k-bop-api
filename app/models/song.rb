class Song < ActiveRecord::Base
  has_many :comments
  has_many :playlist_entries
  has_many :playlists, through: :playlist_entries
  validates :uri, :presence => true, :uniqueness => true
  
end
