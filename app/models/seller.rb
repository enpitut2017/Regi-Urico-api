class Seller < ApplicationRecord
  has_many :events
  has_many :items
end
