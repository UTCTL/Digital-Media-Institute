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
#  admin           :boolean
#

require 'spec_helper'

describe User do
  pending "add some examples to (or delete) #{__FILE__}"
end
