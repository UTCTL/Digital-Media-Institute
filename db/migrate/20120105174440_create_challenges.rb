class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.integer :skill_id
      t.integer :position
      t.string :title
      t.text :content
      t.string :assets

      t.timestamps
    end
  end
end
