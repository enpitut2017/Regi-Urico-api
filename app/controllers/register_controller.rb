# frozen_string_literal: true

class RegisterController < ApplicationController
  before_action :current_seller

  def create
    json_request = JSON.parse(request.body.read)
    items = json_request['items']
    if items.nil? then
      render status: :bad_request
    else
      begin
        tweets = []
        ActiveRecord::Base.transaction do
          items.each do |item|
            event_item = EventItem.find_by(event_id: json_request['event_id'], item_id: item['id'])
            if event_item.nil? || ! @seller.events.ids.include?(event_item.event_id)
              raise ArgumentError, "there is no such item, event_id: #{json_request['event_id']}, item_id: #{item['id']}"
            end

            event_item.logs.create(diff_count: item['count'])
            item = Item.find(item['id'])
            tweet = "#{item.seller.name}様の「#{item.name}」は残り#{event_item.logs.sum(:diff_count)}個になりました！"
            tweets.push(tweet)
          end
          @event = Event.find(json_request['event_id'])
        end
        client = get_client
        tweets.each do |tweet|
          client.update!(tweet)
        end
        render json: @event, include: {event_items: :item}, status: :created
      rescue => e
        render json: {errors: e.message}, status: :bad_request
      end
    end
  end

  private

  def get_client
    Twitter::REST::Client.new do |config|
      config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: {errors: 'Unauthorized'}, status: :unauthorized
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
