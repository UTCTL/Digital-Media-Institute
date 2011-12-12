class AddFieldsToLessons < ActiveRecord::Migration
  def change
    change_table :lessons do |t|
      t.string :type
      t.string :link
    end
  end
end
