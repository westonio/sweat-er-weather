class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, confirmation: true
  validates :api_key, presence: true, length: { is: 36 }
  has_secure_password

  def self.create_with_api_key(user_params) 
    user = User.create do |user|
      user.email = user_params[:email]
      user.password = user_params[:password]
      user.password_confirmation = user_params[:password_confirmation]
      user.api_key = SecureRandom.uuid
    end
    user
  end
end