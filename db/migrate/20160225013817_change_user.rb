class ChangeUser < ActiveRecord::Migration
  def change
    remove_column :users, :expiration
    add_column :users, :login_data, :text
  end
end
