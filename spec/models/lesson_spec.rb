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
    
    it "should have non blank content" do
      lesson = @skill.lessons.create(@attr.merge( :content => "" ))
      
      lesson.should_not be_valid
    end
    
  end
  
end
