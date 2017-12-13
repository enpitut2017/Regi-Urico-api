class Event < ApplicationRecord
  has_many :event_items
  belongs_to :seller
  validates :name, presence: true, length: {minimum: 1}
end
