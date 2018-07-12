# == Schema Information
#
# Table name: users
#
#  id              :bigint(8)        not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :password_digest, presence: true
  validates :session_token, :username, presence: true, uniqueness: true
  
  after_initialize :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests
    
  attr_reader :password
  
  def self.find_by_credentials(user_name, password)
    user = User.find_by(username: user_name)
    return user if user && user.is_password?(password)
    nil
  end 
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64
    self.save
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest) == password
  end
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end 
  
end
