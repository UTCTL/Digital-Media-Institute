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

require 'spec_helper'

describe SkillChallenge do
  
  describe "associations" do
    it "has challenge attibute" do
      sc = SkillChallenge.new
      sc.should respond_to(:challenge)
    end
    
    it "has skill attribute" do
      sc = SkillChallenge.new
      sc.should respond_to(:skill)
    end
  end
end
