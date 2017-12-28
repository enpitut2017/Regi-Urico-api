class Event < ApplicationRecord
  has_many :event_items
  has_many :sales_logs
  belongs_to :seller
  validates :name, presence: true, length: {minimum: 1}
end
