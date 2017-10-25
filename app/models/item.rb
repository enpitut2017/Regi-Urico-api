class Item < ApplicationRecord
  has_one :event_item
  belongs_to :seller
end
