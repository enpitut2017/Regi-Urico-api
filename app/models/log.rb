class Log < ApplicationRecord
  belongs_to :event_item
  belongs_to :sales_log, optional: true
end
