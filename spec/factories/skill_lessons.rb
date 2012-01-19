# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skill_lesson do
    skill_id 1
    lesson_id 1
    list_scope 1
    position 1
  end
end
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

