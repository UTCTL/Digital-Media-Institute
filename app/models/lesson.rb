# == Schema Information
#
# Table name: lessons
#
#  id         :integer         not null, primary key
#  skill_id   :integer
#  title      :string(255)
#  content    :text
#  thumbnail  :string(255)
#  list_scope :integer
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Lesson < ActiveRecord::Base
  
end
