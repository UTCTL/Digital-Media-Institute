# == Schema Information
#
# Table name: submissions
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  attachment   :string(255)
#  link         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#
require 'spec_helper'

describe Submission do
  before(:each) do 
    @attr = FactoryGirl.attributes_for(:submission)
  end
  
  # it "must have an attachment or link, but not both" do
  #   sub = Submission.new(@attr.merge({:link => "alink"}))

  #   sub.should_not be_valid
  # end

  it "must have a user_id" do
    sub = Submission.new(@attr.merge({:user_id => nil}))

    sub.should_not be_valid
  end

end

