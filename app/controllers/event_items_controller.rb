class EventItemsController < ApplicationController
  before_action :current_seller

  def create
    json_request = JSON.parse(request.body.read)
    event_id = json_request['event_id']
    event = Event.find_by(id: event_id)
    if event.nil?
      # イベントが存在しない
      return render json: {'errors': 'Event is not found.'}, status: :not_found
    elsif event.seller != @seller
      # イベントの所有者がトークンの所有者と異なる
      return render json: {errors: 'Permission denied'}, status: :forbidden
    end
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

    items = event_items(event_id)
    render json: {items: items}
  end

  def update
    json_request = JSON.parse(request.body.read)
    item_id = json_request['item_id']
    event_id = json_request['event_id']
    item = Item.find_by(id: item_id)
    event = Event.find_by(id: event_id)
    if item.nil? || event.nil?
      # アイテムかイベントが存在しない
      errors = []
      errors.push('Item is not found.') if item.nil?
      errors.push('Event is not found.') if event.nil?
      return render json: {'errors': errors}, status: :not_found
    end
    if item.seller != @seller || event.seller != @seller
      # アイテムかイベントの所有者がトークンの所有者と異なる
      return render json: {errors: 'Permission denied'}, status: :forbidden
    end
    event_item = EventItem.find_by(item_id: item_id, event_id: event_id)

    # event_itemの更新
    if event_item
      name = json_request['name'] || Item.find(event_item.item_id).name
      price = json_request['price'] || event_item.price
      event_item.update(price: price)
      Item.find(event_item.item_id).update(name: name)
    end

    items = event_items(event_id)

    if event_item
      render json: {items: items}
    else # 指定されたアイテムが存在しなかった場合、最新のitemsとともに404(not found)を返す
      render json: {items: items}, status: :not_found
    end
  end

  def destroy
    json_request = JSON.parse(request.body.read)
    item_id = json_request['item_id']
    event_id = json_request['event_id']
    item = Item.find_by(id: item_id)
    event = Event.find_by(id: event_id)
    if item.nil? || event.nil?
      # アイテムかイベントが存在しない
      errors = []
      errors.push('Item is not found.') if item.nil?
      errors.push('Event is not found.') if event.nil?
      return render json: {'errors': errors}, status: :not_found
    end
    if item.seller != @seller || event.seller != @seller
      # アイテムかイベントの所有者がトークンの所有者と異なる
      return render json: {errors: 'Permission denied'}, status: :forbidden
    end
    # event_itemの削除
    result = EventItem.where(item_id: item_id, event_id: event_id).destroy_all

    items = event_items(event_id)
    if result.empty? # アイテムが何も削除されなかったなら、最新のitemsとともに404(not found)を返す
      render json: {items: items}, status: :not_found
    else # アイテムが削除されたら、最新のitemsを返す
      render json: {items: items}
    end
  end

  private

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end

  def event_items(event_id)
    items = []
    EventItem.where(event_id: event_id).each do |event_item|
      item = {
          item_id: event_item.item_id,
          event_id: event_item.event_id,
          name: Item.find(event_item.item_id).name,
          price: event_item.price,
          count: event_item.logs.pluck(:diff_count).sum,
      }
      items.push(item)
    end
    return items
  end
end
