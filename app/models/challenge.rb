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

  attr_accessible :title, :content, :assets, :submission_type
  
  validates :title, :presence => true
  validates :content, :presence => true

  # gets a list of challenges in the same category
  def relatedChallenges
    Challenge.all(:select => "challenges.*,skill_challenges.parent_id",
                   :joins => :skill_challenges,
                   :conditions => { 
                     :skill_challenges => { :parent_id => self.skill_challenges.first.parent_id }
                   },
                   :order => "skill_challenges.lft")
  end
  
end


