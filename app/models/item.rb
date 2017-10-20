class Item < ApplicationRecord
  has_many :event_items
  belongs_to :seller
end
