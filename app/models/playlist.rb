class Playlist < ActiveRecord::Base
  has_many :playlists_songs
  has_many :songs, through: :playlists_songs
  belongs_to :user
  validate :song_uniqueness

  protected

  def song_uniqueness
    if songs.length != songs.uniq.length
      errors[:songs] = "That song is already in the playlist"
    end
  end
end
