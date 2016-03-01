class RenamePlaylistsSongs < ActiveRecord::Migration
  def change
    rename_table :playlists_songs, :playlist_entries
  end
end
