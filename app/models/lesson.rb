# == Schema Information
#
# Table name: lessons
#
#  id               :integer         not null, primary key
#  title            :string(255)
#  content          :text
#  thumbnail        :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  kind             :string(255)
#  link             :string(255)
#  assets           :string(255)
#  submission_type  :string(255)
#  allow_submission :boolean
#

class Lesson < ActiveRecord::Base
  has_many :skill_lessons, :dependent => :delete_all
  has_many :skills, :through => :skill_lessons
  has_many :submissions, :as => :answerable

  attr_accessible :title, :content, :kind, :link, :thumbnail, :assets, :submission_type,
    :allow_submission

  
  KINDS = ["Video","Link","Text"]
  
  validates :kind, :inclusion => { :in => KINDS, :message => "%{value} is not a valid kind" }
  validates :content, :presence => true, :if => :isText?
  validates :link, :presence => true, :if => :isExternal?
  validates :title, :presence => true
  
  
  def isText?
    kind == "Text"
  end
  
  def isExternal?
    (kind == "Link" || kind == "Video")
  end
end
