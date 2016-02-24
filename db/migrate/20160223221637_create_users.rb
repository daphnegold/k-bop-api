class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :provider
      t.string :token
      t.integer :expiration

      t.timestamps null: false
    end
  end
end
