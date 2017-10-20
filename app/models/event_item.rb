class EventItem < ApplicationRecord
  belongs_to :Event
  belongs_to :Item
end
