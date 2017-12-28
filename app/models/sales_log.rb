class SalesLog < ApplicationRecord
  belongs_to :event
  has_many :logs, :dependent => :delete_all
  has_many :event_items, through: :logs
  validates :deposit, presence: true, numericality: {greater_than_or_equal_to: 0}
end
