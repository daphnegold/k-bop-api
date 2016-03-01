class PlaylistEntry < ActiveRecord::Base
  belongs_to :playlist
  belongs_to :song
  validates :song, :presence => true
  validates :playlist, :presence => true
  validate :entry_uniqueness

  protected

  def entry_uniqueness
    if PlaylistEntry.where(song: song, playlist: playlist).count > 0
      errors[:song] = "That song is already in that playlist"
    end
  end
end
