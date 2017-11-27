class Seller < ApplicationRecord
  has_secure_password
  validates :name, presence: true, uniqueness: true
  validates :password_digest, presence: true, length: { minimum: 8 }
  has_many :events
  has_many :items
end
