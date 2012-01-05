# == Schema Information
#
# Table name: challenges
#
#  id         :integer         not null, primary key
#  skill_id   :integer
#  position   :integer
#  title      :string(255)
#  content    :text
#  assets     :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Challenge do
  
  before(:each) do
    @skill = FactoryGirl.create(:skill)
    @attr = FactoryGirl.attributes_for(:challenge)
  end
  
  it "should create object with valid attributes" do
    @skill.challenges.create(@attr)
  end
  
  describe "validations" do
    it "should require a skill_id" do
      Challenge.new(@attr).should_not be_valid
    end
    
    it "should require a title" do
      challenge = @skill.challenges.create(@attr.merge(:title => ''))
      challenge.should_not be_valid
    end
    
    it "should require content" do
      challenge = @skill.challenges.create(@attr.merge(:content => ''))
      challenge.should_not be_valid
    end
  end
end


