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

class Submission < ActiveRecord::Base
  include LessonsHelper

  belongs_to :user
  belongs_to :answerable, :polymorphic => true
  
  MEDIA_TYPES = %w(image video link)

  mount_uploader :attachment, SubmissionUploader

  validates :user_id, :presence => true
  validates :attachment, :presence => true, :if => "media_type == 'image'"
  validates :link, :presence => true, :if => "media_type == 'link' || media_type == 'video'"
  validates :media_type, :inclusion => { :in => MEDIA_TYPES }

  validate :video_link?, :if => "media_type == 'video'"

  def video_link?
    if !( link.match(VIMEO_REGEX) || link.match(YOUTUBE_REGEX))
      errors.add( :link, "must be a Youtube or Vimeo link" )
    end
  end

  
end
