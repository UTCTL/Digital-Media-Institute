class AddAssetsToLesson < ActiveRecord::Migration
  def change
    add_column :lessons, :assets, :string
  end
end
