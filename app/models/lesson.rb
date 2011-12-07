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
  acts_as_list :scope => [:skill_id,:list_scope]
  
  attr_accessible :title, :content, :thumbnail, :list_scope
  
  validates :skill_id, :presence => true
  validates :list_scope, :numericality => { 
                                            :only_integer => true,
                                            :greater_than_or_equal_to => 1, 
                                            :less_than_or_equal_to => 2
                                          }
  validates :content, :presence => true 
  
  belongs_to :skill 
end
