class CreateSubmissions < ActiveRecord::Migration
  def change
    create_table :submissions do |t|
      t.integer :user_id
      t.integer :challenge_id
      t.string :attachment
      t.string :link

      t.timestamps
    end
  end
end
