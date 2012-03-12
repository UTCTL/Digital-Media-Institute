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

    it "requires a title if root node (it is a challenge category)" do
      sc = SkillChallenge.new(:skill_id => 1)
      sc.should_not be_valid

    end

    it "requires a challenge_id if it is a child node" do
      cat = SkillChallenge.create(:skill_id => 1, :title => "Test Category")
      sc = SkillChallenge.new(:parent_id => cat.id)

      sc.should_not be_valid

    end

    it "requires a skill_id" do
      sc = SkillChallenge.new(:title => "Test1")

      sc.should_not be_valid
    end

  end
end
