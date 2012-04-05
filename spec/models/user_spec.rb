# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)
#  encrypted_password     :string(255)
#  about_me               :text
#  url                    :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  display_name           :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string(255)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string(255)
#  failed_attempts        :integer         default(0)
#  unlock_token           :string(255)
#  locked_at              :datetime
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
