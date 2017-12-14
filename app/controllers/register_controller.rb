class RegisterController < ApplicationController
  before_action :current_seller

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
            tweet << "\n" << "#{item.seller.name}の「#{item.name}」は残り#{event_item.logs.sum(:diff_count)}冊になりました！"
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

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end
  end