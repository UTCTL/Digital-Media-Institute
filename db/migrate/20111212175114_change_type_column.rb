class ChangeTypeColumn < ActiveRecord::Migration
  def up
    change_table :lessons  do |t|
      t.rename :type, :kind
    end
  end

  def down
    change_table :lessons  do |t|
      t.rename :kind, :type
    end
  end
end
