# == Schema Information
#
# Table name: challenges
#
#  id         :integer         not null, primary key
#  skill_id   :integer
#  position   :integer
#  title      :string(255)
#  content    :text
#  assets     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Challenge < ActiveRecord::Base
  acts_as_list :scope => :skill_id
  
  attr_accessible :title, :content, :assets
  
  validates :skill_id, :presence => true
  validates :title, :presence => true
  validates :content, :presence => true
  
  belongs_to :skill
end


