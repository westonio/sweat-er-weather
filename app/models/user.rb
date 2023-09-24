class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, confirmation: true
  has_secure_password

  
end