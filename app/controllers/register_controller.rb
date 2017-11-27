class RegisterController < ApplicationController
  def create
    json_request = JSON.parse(request.body.read)
    items = json_request["items"]
    if items.nil?
      render status: :bad_request
    else
      begin
        tweet = ""
        ActiveRecord::Base.transaction do
          items.each do |item|
            event_item = EventItem.find_by(event_id: json_request["event_id"], item_id: item["id"])
            raise ArgumentError if event_item.nil?
            event_item.logs.create(diff_count: item["count"])
            item = Item.find(item["id"])
            tweet << "\n" << "#{item.seller.name}様の「#{item.name}」は残り#{event_item.logs.sum(:diff_count)}個になりました！"
          end
          @event = Event.find(json_request["event_id"])
        end
        client = get_client
        client.update!(tweet)
        render json: @event, include: {event_items: :item}, status: :created
      rescue => e
        logger.error e
        render status: :bad_request
      end
    end
  end
  
private
  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
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