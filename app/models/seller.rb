class Seller < ApplicationRecord
  has_secure_password
  has_secure_token
  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 8 }
  has_many :events
  has_many :items
end
