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
        # event を確認
        event = Event.find_by(id: json_request['event_id'])
        if event.nil?
          # イベントが存在しない場合
          return render json: { 'errors': { event_id: ['is not found'] }}, status: :not_found
        elsif @seller.events.find_by(id: event.id).nil?
          # イベントが他人のものである場合
          return render json: { 'errors': { event_id: ['is not yours'] }}, status: :forbidden
        end
        ActiveRecord::Base.transaction do
          items.each do |item|
            if item['count'].nil?
              # count が存在しない場合
              return render json: { 'errors': { count: ['is not found'] }}, status: :bad_request
            end
            # 販売数が 0 だった場合は記録せずにスキップする
            next if item['count'].zero?
            event_item = EventItem.find_by(event_id: json_request['event_id'], item_id: item['id'])
            if event_item.nil?
              # アイテムが見つからない場合
              return render json: { 'errors': { id: ['is not found'] }}, status: :not_found
            end
            event_item.logs.create(diff_count: item['count'])
            item = Item.find_by(id: item['id'])
            tweet = "#{item.seller.name}の「#{item.name}」は残り#{event_item.logs.sum(:diff_count)}個になりました！"
            tweets.push(tweet)
          end
        end
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
            twitter_update(sliced_tweet)
          end
          twitter_update(did_continue * (first_tweet ? 0 : 1) + tweet)
        end

        # 最新のアイテムリストを返す
        items = []
        event.event_items.each do |event_item|
          item = Item.find_by(id: event_item.item_id)
          price = EventItem.find_by(item_id: item.id).price
          count = event_item.logs.sum(:diff_count)
          items.push({
                         price: price,
                         id: item.id,
                         name: item.name,
                         count: count,
                         diff_count: 0,
                     })
        end
        render json: { event_id: event.id, name: event.name, items: items }
      rescue => e
        render json: {errors: e.message}, status: :bad_request
      end
    end
  end

  private

  def get_client
    if @seller.twitter_token.nil?
      # Twitter アカウントが登録されていない場合、@nearbuy_enpit17 を使用する
      Twitter::REST::Client.new do |config|
        config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token         = ENV['TWITTER_ACCESS_TOKEN']
        config.access_token_secret  = ENV['TWITTER_ACCESS_TOKEN_SECRET']
      end
    else
      # Twitter アカウントが登録されていれば、そのアカウントを使用する
      Twitter::REST::Client.new do |config|
        config.consumer_key         = ENV['TWITTER_CONSUMER_KEY']
        config.consumer_secret      = ENV['TWITTER_CONSUMER_SECRET']
        config.access_token         = @seller.twitter_token
        config.access_token_secret  = @seller.twitter_secret
      end
    end
  end

  private

  def twitter_update(tweet)
    client = get_client()
    begin
      client.update!(tweet)
    rescue Twitter::Error::DuplicateStatus => e
      time_string = Time.now.strftime('%Y/%m/%d %H:%M')
      client.update!("#{tweet} (#{time_string})")
    end
  end

  def current_seller
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: { errors: { token: ['is not authorized'] }}, status: :unauthorized
    end
  end
end
