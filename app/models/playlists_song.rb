class PlaylistsSong < ActiveRecord::Base
  validate :entry_uniqueness
  belongs_to :playlist
  belongs_to :song

  protected

  def entry_uniqueness
    if PlaylistsSong.where(song: song, playlist: playlist).count > 0
      errors[:song] = "That song is already in that playlist"
    end
  end
end
