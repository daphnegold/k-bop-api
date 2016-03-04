class Song < ActiveRecord::Base
  has_many :comments
  has_many :playlist_entries
  has_many :playlists, through: :playlist_entries
  validates :uri, :presence => true, :uniqueness => true

  def self.get_comments(track_uri)
    song = Song.find_by(uri: track_uri)

    if song
      return song.comments
    else
      return []
    end
  end

  def self.get_likes(track_uri)
    song = Song.find_by(uri: track_uri)

    if song
      return song.likes
    else
      return 0
    end
  end
end
