class Item < ApplicationRecord
  has_many :EventItem
  belongs_to :Seller
end
