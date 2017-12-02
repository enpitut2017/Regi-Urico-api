class Item < ApplicationRecord
  validates :name, presence: true
  has_one :event_item
  belongs_to :seller
end
