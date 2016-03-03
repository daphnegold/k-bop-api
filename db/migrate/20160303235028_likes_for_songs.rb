class LikesForSongs < ActiveRecord::Migration
  def change
    add_column :songs, :likes, :integer, default: 0
  end
end
