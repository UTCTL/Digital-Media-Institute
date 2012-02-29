# == Schema Information
#
# Table name: submissions
#
#  id              :integer         not null, primary key
#  user_id         :integer
#  attachment      :string(255)
#  link            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  media_type      :string(255)
#  answerable_id   :integer
#  answerable_type :string(255)
#

require 'spec_helper'

describe Submission do
  before(:each) do 
    @attr = FactoryGirl.attributes_for(:submission)
  end
  
  it "must have a link if media type is Video"
  it "must have a link if media type is Link"
  it "must have an attachment if media type is image"
  it "must a have media type in the allowed list" do

  end


  it "must have a user_id" do
    sub = Submission.new(@attr.merge({:user_id => nil}))

    sub.should_not be_valid
  end

end

