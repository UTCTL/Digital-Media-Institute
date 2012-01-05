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
#  kind       :string(255)
#  link       :string(255)
#

class Lesson < ActiveRecord::Base
  acts_as_list :scope => [:skill_id,:list_scope]
  
  attr_accessible :title, :skill_id, :content, :kind, :link, :thumbnail, :list_scope
  
  KINDS = ["Video","Link","Text"]
  
  validates :skill_id, :presence => true
  validates :kind, :inclusion => { :in => KINDS, :message => "%{value} is not a valid kind" }
  validates :list_scope, :numericality => { 
                                            :only_integer => true,
                                            :greater_than_or_equal_to => 1, 
                                            :less_than_or_equal_to => 2
                                          }
  validates :content, :presence => true, :if => :isText?
  validates :link, :presence => true, :if => :isExternal?
  validates :title, :presence => true
  
  belongs_to :skill 
  
  scope :primary_lessons, where("list_scope = 1")
  scope :other_lessons, where("list_scope = 2")
  
  def isText?
    kind == "Text"
  end
  
  def isExternal?
    (kind == "Link" || kind == "Video")
  end
end
