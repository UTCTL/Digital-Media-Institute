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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :confirmable, :lockable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :about_me, 
                  :display_name, :url, :first_name, :last_name

  # has_secure_password
  after_initialize :init_values
  before_create :set_default_role

  default_scope :order => :last_name

  email_regex= /\A[^@]+@[^@]*utexas\.edu\z/
  ROLES = %w( anonymous user content_editor admin )

  validates :email, :presence => true, 
                    :uniqueness => {:case_sensitive => false}, 
                    :format => {:with => email_regex,
                                :message => "must be a valid utexas.edu email address"
                               }

  validates :display_name, :presence => true
  validates :password, :presence => true, :length => { :within => 7..40 }, :unless => :has_digest?
  validates :password_confirmation, :presence => true, :unless => :has_digest?
  validates :role, :inclusion => { :in => ROLES }

  def authorized?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(self.role)
  end

protected

  def has_digest?
    self.encrypted_password.present?
  end

  def init_values
    self.role ||= "anonymous"
  end

  def set_default_role
    self.role = "user"
  end
end
