# == Schema Information
#
# Table name: skill_lessons
#
#  id         :integer         not null, primary key
#  skill_id   :integer
#  lesson_id  :integer
#  list_scope :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class SkillLesson < ActiveRecord::Base
  acts_as_list :scope => [:skill_id,:list_scope]
  
  attr_accessible :skill_id, :lesson_id, :list_scope
  
  belongs_to :skill
  belongs_to :lesson
  
  validates :skill_id, :presence => true
  validates :lesson_id, :presence => true
  validates :list_scope, :inclusion => {:in => 1..2}
end


