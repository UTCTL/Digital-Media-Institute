# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :skill_challenge do
    skill_id 1
    challenge_id 1
    list_scope 1
    position 1
  end
end
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

