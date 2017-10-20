class EventItem < ApplicationRecord
  belongs_to :event
  belongs_to :item
end
