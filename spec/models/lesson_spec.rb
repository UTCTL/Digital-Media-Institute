# == Schema Information
#
# Table name: lessons
#
#  id         :integer         not null, primary key
#  skill_id   :integer
#  title      :string(255)
#  content    :text
#  thumbnail  :string(255)
#  list_scope :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Lesson do
  
  before(:each) do
    @skill = FactoryGirl.create(:skill)
    @attr = FactoryGirl.attributes_for(:lesson)
  end
  
  it "should create object with valid attributes" do
    
    @skill.lessons.create!(@attr)
  end
  
  describe "validations" do
    
    it "should have a skill_id" do
      Lesson.new(@attr).should_not be_valid
    end
    
    it "should have a list scope of 1 or 2" do
      lesson = @skill.lessons.create(@attr.merge(:list_scope => 4))
      
      lesson.should_not be_valid
    end
    
    it "should have a kind should be in the list of valid types" do
      lesson = @skill.lessons.create(@attr.merge(:kind => "Invalid"))
      
      lesson.should_not be_valid
    end
    
    it "should have a link if type is Video or Link" do
      lesson = @skill.lessons.create(@attr.merge(:kind => "Link",:link => ""))
      
      lesson.should_not be_valid
    end
    
    it "should have non blank content if kind is Text" do
      lesson = @skill.lessons.create(@attr.merge(:kind => "Text",:content => ""))
      
      lesson.should_not be_valid
    end
    
    it "should allow blank content for kinds other than Text" do
      lesson = @skill.lessons.create(@attr.merge(:kind => "Link",:content => ""))
      
      lesson.should be_valid
    end
    
  end
  
end
