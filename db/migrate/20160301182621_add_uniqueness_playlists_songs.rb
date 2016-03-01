class AddUniquenessPlaylistsSongs < ActiveRecord::Migration
  def change
    add_index :playlists_songs, [:playlist_id, :song_id], :unique => true
  end
end
