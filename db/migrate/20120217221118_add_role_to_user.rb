class AddRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :role, :string

    User.reset_column_information
    User.all.each do |user|
      if(user.admin?)
        user.update_attributes!(:role => "admin")
      else
        user.update_attributes!(:role => "user")
      end
    end

    remove_column :users, :admin
  end
end
