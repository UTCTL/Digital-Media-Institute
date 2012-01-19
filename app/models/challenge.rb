# == Schema Information
#
# Table name: challenges
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  assets     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Challenge < ActiveRecord::Base
  has_many :skill_challenges
  has_many :skills, :through => :skill_challenges
  
  attr_accessible :title, :content, :assets
  
  validates :title, :presence => true
  validates :content, :presence => true
  
end


