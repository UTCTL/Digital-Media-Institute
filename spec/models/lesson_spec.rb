# == Schema Information
#
# Table name: lessons
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  content    :text
#  thumbnail  :string(255)
#  created_at :datetime
#  updated_at :datetime
#  kind       :string(255)
#  link       :string(255)
#

require 'spec_helper'

describe Lesson do
  
  before(:each) do
    @attr = FactoryGirl.attributes_for(:lesson)
  end
  
  it "should create object with valid attributes" do
    
    Lesson.create!(@attr)
  end
  
  describe "associations" do
    it "has skill_lessons attribute" do
      l = Lesson.new
      l.should respond_to(:skill_lessons)
    end
    
    it "has skills attribute" do
      l = Lesson.new
      l.should respond_to(:skills)
    end
  end
  
  describe "validations" do
    
    it "should require a title" do
      lesson = Lesson.create(@attr.merge(:title => ''))
      lesson.should_not be_valid
    end
    
    
    it "should have a kind should be in the list of valid types" do
      lesson = Lesson.create(@attr.merge(:kind => "Invalid"))
      
      lesson.should_not be_valid
    end
    
    it "should have a link if type is Video or Link" do
      lesson = Lesson.create(@attr.merge(:kind => "Link",:link => ""))
      
      lesson.should_not be_valid
    end
    
    it "should have non blank content if kind is Text" do
      lesson = Lesson.create(@attr.merge(:kind => "Text",:content => ""))
      
      lesson.should_not be_valid
    end
    
    it "should allow blank content for kinds other than Text" do
      lesson = Lesson.create(@attr.merge(:kind => "Link",:content => ""))
      
      lesson.should be_valid
    end
    
  end
  
end
