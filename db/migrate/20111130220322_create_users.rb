class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password
      t.text :about_me
      t.string :url
      t.string :first_name
      t.string :last_name
      t.string :display_name

      t.timestamps
    end
  end
end
