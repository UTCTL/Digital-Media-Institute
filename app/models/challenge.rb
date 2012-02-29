# == Schema Information
#
# Table name: challenges
#
#  id              :integer         not null, primary key
#  title           :string(255)
#  content         :text
#  assets          :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  submission_type :string(255)
#

class Challenge < ActiveRecord::Base
  has_many :skill_challenges
  has_many :skills, :through => :skill_challenges
  has_many :submissions, :as => :answerable

  attr_accessible :title, :content, :assets
  
  validates :title, :presence => true
  validates :content, :presence => true
  
end


