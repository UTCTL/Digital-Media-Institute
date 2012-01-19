# == Schema Information
#
# Table name: skill_challenges
#
#  id           :integer         not null, primary key
#  skill_id     :integer
#  challenge_id :integer
#  list_scope   :integer
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class SkillChallenge < ActiveRecord::Base
  acts_as_list
  
  belongs_to :skill
  belongs_to :challenge
end
