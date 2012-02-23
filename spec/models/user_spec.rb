# == Schema Information
#
# Table name: users
#
#  id              :integer         not null, primary key
#  email           :string(255)
#  password_digest :string(255)
#  about_me        :text
#  url             :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  display_name    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  role            :string(255)
#

require 'spec_helper'

describe User do
  before(:each) do
    @attr = FactoryGirl.attributes_for(:user)
  end

  it "creates an object with valid attributes" do
    User.create!(@attr)
  end

  it "requires an email" do
    user = User.create(@attr.merge(:email => ''))

    user.should_not be_valid
  end

  it "requires password and confirmation on sign up" do
    user = User.create(@attr.merge(:password => '',:password_confirmation => ''))

    user.should_not be_valid

  end

  it "does not require password and confirmation if digest is present" do
    user = User.create(@attr);

    user.reload

    user.should be_valid
  end

  it "requires a role in the designated list" do
    user = User.new()
    user.role = "invalid"


    user.should_not be_valid
  end
end
