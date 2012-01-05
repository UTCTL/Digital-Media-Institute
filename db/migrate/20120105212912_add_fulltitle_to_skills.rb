class AddFulltitleToSkills < ActiveRecord::Migration
  def change
    change_table :skills do |t|
      t.string :fulltitle
    end
  end
end
