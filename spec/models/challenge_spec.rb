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

require 'spec_helper'

describe Challenge do
  
  before(:each) do
    @attr = FactoryGirl.attributes_for(:challenge)
  end
  
  it "should create object with valid attributes" do
    Challenge.create(@attr)
  end
  
  describe "associations" do
    it "has skill_challenges attribute" do
      c = Challenge.new
      c.should respond_to(:skill_challenges)
    end
    it "has skills attribute" do
      c = Challenge.new
      c.should respond_to(:skills)
    end

    it "has submissions attribute" do
      c = Challenge.new
      c.should respond_to(:submissions)
    end
  end
  
  describe "validations" do
    
    it "should require a title" do
      challenge = Challenge.create(@attr.merge(:title => ''))
      challenge.should_not be_valid
    end
    
    it "should require content" do
      challenge = Challenge.create(@attr.merge(:content => ''))
      challenge.should_not be_valid
    end
  end
end


