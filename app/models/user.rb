class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, confirmation: true
  validates :api_key, presence: true, length: { is: 36 }
  has_secure_password
  
  before_validation :generate_api_key, on: :create

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end
end