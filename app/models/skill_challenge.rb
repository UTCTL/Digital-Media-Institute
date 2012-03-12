# == Schema Information
#
# Table name: skill_challenges
#
#  id           :integer         not null, primary key
#  skill_id     :integer
#  challenge_id :integer
#  created_at   :datetime
#  updated_at   :datetime
#  parent_id    :integer
#  lft          :integer
#  rgt          :integer
#  title        :string(255)
#

class SkillChallenge < ActiveRecord::Base
  acts_as_nested_set :scope => :skill_id
  
  attr_accessible :skill_id, :challenge_id, :parent_id, :title
  
  belongs_to :skill
  belongs_to :challenge

  validates :skill_id, :presence => true
  validates :title, :presence => true, :if => "parent_id.nil?"
  # validates :challenge_id, :presence => true, :unless => "parent_id.nil?"

end
