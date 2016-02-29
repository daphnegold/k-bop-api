class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.string :uri

      t.timestamps null: false
    end
  end
end
