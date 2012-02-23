# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :submission do
    user_id 1
    challenge_id 1
    attachment "MyString"
    link ""
  end
end
# == Schema Information
#
# Table name: submissions
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  attachment   :string(255)
#  link         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

