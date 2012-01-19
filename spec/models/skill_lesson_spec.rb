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

require 'spec_helper'

describe SkillLesson do
  describe "associations" do
    it "has skill attribute" do
      sl = SkillLesson.new
      sl.should respond_to(:skill)
    end
    it "has lesson attribute" do
      sl = SkillLesson.new
      sl.should respond_to(:lesson)
    end
  end
  
  describe "list scope" do
    
    before(:each) do
      SkillLesson.create(:skill_id => 1, :lesson_id => 1, :list_scope => 1)
      SkillLesson.create(:skill_id => 1, :lesson_id => 2, :list_scope => 1)
      SkillLesson.create(:skill_id => 1, :lesson_id => 3, :list_scope => 2)
      SkillLesson.create(:skill_id => 1, :lesson_id => 4, :list_scope => 2)
      SkillLesson.create(:skill_id => 2, :lesson_id => 6, :list_scope => 1)
      SkillLesson.create(:skill_id => 2, :lesson_id => 6, :list_scope => 2)
    end
    
    it "correctly numbers items with different list scopes" do
      item = SkillLesson.create(:skill_id => 1, :lesson_id => 7, :list_scope => 1)
      
      item.position.should == 3
    end
    
    it "correctly numbers items in different skills" do
      item = SkillLesson.create(:skill_id => 2, :lesson_id => 8, :list_scope => 1)
      
      item.position.should == 2
    end
    
  end
  
  describe "validations" do
    it "requires a skill_id" do
      item = SkillLesson.create(:lesson_id => 1, :list_scope => 1)
      
      item.should_not be_valid
    end
    it "requires a lesson_id" do
      item = SkillLesson.create(:skill_id => 1, :list_scope => 1)
      
      item.should_not be_valid
    end
    it "requires a list_scope of 1 or 2" do
      
      item = SkillLesson.create(:skill_id => 1, :lesson_id => 1, :list_scope => 5)
      
      item.should_not be_valid
    end
    
  end
end
