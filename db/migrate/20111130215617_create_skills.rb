class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.string :title
      t.text :description
      t.string :icon
      t.string :slug
      t.integer :lft
      t.integer :rgt
      t.integer :parent_id

      t.timestamps
    end
  end
end
