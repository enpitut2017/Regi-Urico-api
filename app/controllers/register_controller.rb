class RegisterController < ApplicationController
  def create
    json_request = JSON.parse(request.body.read)
    items = json_request["items"]
    if items.nil?
      render status: :bad_request
    else
      begin
        ActiveRecord::Base.transaction do
          items.each do |item|
            event_item = EventItem.find_by(event_id: json_request["event_id"], item_id: item["id"])
            raise ArgumentError if event_item.nil?
            event_item.logs.create(diff_count: item["count"])
          end
          render status: :created
        end
      rescue
        render status: :bad_request
      end
    end
  end
end
# return:JSON
# {
#   "id": ~,
#   "items": [
#     { "id": ~, "name": ~, "sum_price": ~ }, ...
#   ],
#   "all_price": ~
# }