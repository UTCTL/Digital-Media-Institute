# == Schema Information
#
# Table name: groupings
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Grouping < ActiveRecord::Base
end
