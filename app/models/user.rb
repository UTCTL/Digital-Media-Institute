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

class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :about_me, 
                  :display_name, :url, :first_name, :last_name
  has_secure_password
  after_initialize :init_values

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  ROLES = %w( anonymous user content_editor admin )

  validates :email, :presence => true, 
                    :uniqueness => {:case_sensitive => false}, 
                    :format => {:with => email_regex}

  validates :password, :presence => true, :length => { :within => 7..40 }, :unless => :has_digest?
  validates :password_confirmation, :presence => true, :unless => :has_digest?

  def authorized?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(self.role)
  end

  def has_digest?
    self.password_digest.present?
  end

  def init_values
    self.role ||= "anonymous"
  end
end
