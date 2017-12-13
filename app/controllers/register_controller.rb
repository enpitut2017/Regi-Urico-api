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
        will_continue = "（続く）"
        did_continue = "（続き）"
        tweet_max_size = 140
        tweets.each do |tweet|
          first_tweet = true
          while did_continue.size * (first_tweet ? 0 : 1) + tweet.size > tweet_max_size
            if first_tweet
              sliced_tweet = tweet.slice!(0, 140 - will_continue.size) + will_continue
              first_tweet = false
            else
              sliced_tweet = did_continue + tweet.slice!(0, 140 - did_continue.size - will_continue.size) + will_continue
            end
            client.update!(sliced_tweet)
          end
          client.update!(did_continue * (first_tweet ? 0 : 1) + tweet)
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
      render json: {errors: {'token': ['is not authorized']}}, status: :unauthorized
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
