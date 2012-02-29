class AddSubmissionFields < ActiveRecord::Migration
  def up
    change_table :submissions do |t|
      t.string :media_type
      t.remove :challenge_id
      t.references :answerable, :polymorphic => true
    end

    change_table :lessons do |t|
      t.string :submission_type
      t.boolean :allow_submission
    end
    
    change_table :challenges do |t|
      t.string :submission_type
    end
  end
  
  def down
    change_table :submissions do |t|
      t.remove :media_type
      t.integer :challenge_id
      t.remove :answerable_id
      t.remove :answerable_type
    end

    change_table :lessons do |t|
      t.remove :submission_type
      t.remove :allow_submission
    end
    
    change_table :challenges do |t|
      t.remove :submission_type
    end
    
  end
end
