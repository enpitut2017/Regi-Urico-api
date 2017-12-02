class EventItemsController < ApplicationController
  before_action :current_seller

  def create
    json_request = JSON.parse(request.body.read)
    event_id = json_request['event_id']
    price = json_request['price']
    item_name = json_request['item_name']
    count = json_request['count']

    begin
      ActiveRecord::Base.transaction do
        # itemの作成
        item = Item.create!(name: item_name, seller_id: @seller.id)

        # event_itemの作成
        event_item = EventItem.create!(
            event_id: event_id,
            item_id: item.id,
            price: price,
        )

        # logの作成
        log = event_item.logs.create!(event_item_id: event_item.id, diff_count: count)
      end
    rescue ActiveRecord::RecordInvalid => e # 情報不足で新規アイテムが作成できなかった場合
      return render json: {'errors': e}, status: :bad_request
    end

    items = []
    EventItem.where(event_id: event_id).each do |event_item|
      item = {
          event_id: event_id,
          item_id: event_item.item_id,
          name: Item.find(event_item.item_id).name,
          price: event_item.price,
          count: event_item.logs.pluck(:diff_count).sum,
      }
      items.push(item)
    end
    render json: {items: items}
  end

  def destroy
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: {errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      item_id = json_request['item_id']
      event_id = json_request['event_id']

      # event_itemの削除
      r = EventItem.where(item_id: item_id, event_id: event_id).destroy_all
      if r.empty? # 削除するアイテムがなかったなら、202(accepted)を返す
        render status: :accepted
      else # アイテムが削除されたら、最新のitemsを返す
        items = []
        EventItem.where(event_id: event_id).each do |event_item|
            item = {
                item_id: event_item.id,
                event_id: event_item.event_id,
                name: Item.find(item_id).name,
                price: event_item.price,
            }
            items.push(item)
        end
        render json: {items: items}
      end
    end
  end

  private

  def current_seller(token)
    seller = Seller.find_by(token: token)
    if seller
      seller
    else
      false
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
