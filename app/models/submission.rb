# == Schema Information
#
# Table name: submissions
#
#  id           :integer         not null, primary key
#  user_id      :integer
#  challenge_id :integer
#  attachment   :string(255)
#  link         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Submission < ActiveRecord::Base
  belongs_to :user
  belongs_to :challenge

  mount_uploader :attachment, SubmissionUploader

  validates :user_id, :presence => true
  validates :attachment, :presence => true
  # validate :attachment_xor_link

  def attachment_xor_link
    if !(attachment.present? ^ link.present?)
      errors.add(:attachment_and_link, "must have attachment OR link")
    end
  end
end
