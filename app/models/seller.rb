class Seller < ApplicationRecord
  has_many :Event
  has_many :Item
end
