class ChangeUsersTable < ActiveRecord::Migration
  def up
    rename_column :users, :password, :password_digest
    add_index :users, :email, :unique => true 
  end

  def down
    rename_column :users, :password_digest, :password
    remove_index :users, :column => :email
  end
end
