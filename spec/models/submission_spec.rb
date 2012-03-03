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
    @image_attr = FactoryGirl.attributes_for(:image_submission)
    @video_attr = FactoryGirl.attributes_for(:video_submission)
    @link_attr = FactoryGirl.attributes_for(:link_submission)
  end
  
  it "must have a link if media type is Video" do
    
    sub = Submission.new(@link_attr.merge({ :link => nil }))
    sub.should_not be_valid
  end

  it "must have a Vimeo or youtube link if type video" do
    sub = Submission.new(@video_attr.merge( { :link => "http://www.cnn.com" } ))
    sub.should_not be_valid

    sub = Submission.new(@video_attr)
    sub.should be_valid
    
    sub = Submission.new(@video_attr.merge( { :link => "http://www.youtube.com/watch?v=tY9DnBNJFTI" } ))
    sub.should be_valid

  end

  it "must have a link if media type is Link" do

    sub = Submission.new(@link_attr.merge({ :link => nil }))
    sub.should_not be_valid
  end
  it "must have an attachment if media type is image" do

    sub = Submission.new(@image_attr.merge({ :attachment => nil }))

    sub.should_not be_valid
  end

  it "must a have media type in the allowed list" do
    sub = Submission.new(@link_attr.merge({ :media_type => 'invalid' }))
    sub.should_not be_valid

  end


  it "must have a user_id" do
    sub = Submission.new(@image_attr.merge({:user_id => nil}))

    sub.should_not be_valid
  end

end

