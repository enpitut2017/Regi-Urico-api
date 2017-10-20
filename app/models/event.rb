class Event < ApplicationRecord
  has_many :EventItem
  belongs_to :Seller
end
