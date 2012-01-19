class CreateSkillLessons < ActiveRecord::Migration
  def change
    create_table :skill_lessons do |t|
      t.integer :skill_id
      t.integer :lesson_id
      t.integer :list_scope
      t.integer :position

      t.timestamps
    end
    
    change_table :lessons do |t|
      t.remove :list_scope, :position, :skill_id
    end
  end
end
