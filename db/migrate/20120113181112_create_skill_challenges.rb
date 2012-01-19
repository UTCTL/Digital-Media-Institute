class CreateSkillChallenges < ActiveRecord::Migration
  def change
    create_table :skill_challenges do |t|
      t.integer :skill_id
      t.integer :challenge_id
      t.integer :list_scope
      t.integer :position

      t.timestamps
    end
    
    change_table :challenges do |t|
      t.remove :skill_id, :position
    end
  end
end
