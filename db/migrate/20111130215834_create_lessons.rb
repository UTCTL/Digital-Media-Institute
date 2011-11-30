class CreateLessons < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.integer :skill_id
      t.string :title
      t.text :content
      t.string :thumbnail
      t.integer :list_scope
      t.integer :position

      t.timestamps
    end
  end
end
