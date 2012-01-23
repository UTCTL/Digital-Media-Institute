class ChangeSkillChallenge < ActiveRecord::Migration
  def change
    change_table :skill_challenges do |t|
      t.remove :position, :list_scope
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.string :title
    end
  end

end
