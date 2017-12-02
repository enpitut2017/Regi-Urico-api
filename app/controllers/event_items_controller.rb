class EventItemsController < ApplicationController
  def create
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: {errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)

      # itemの作成
      item = Item.create(name: json_request['item_name'], seller_id: seller.id)
      p '!!! item:', item
      if item.valid? # => true
        p 'item valid'
      else
        p 'item invalid!'
      end

      # event_itemの作成
      event_item = EventItem.create(
          event_id: json_request['event_id'],
          item_id: item.id,
          price: json_request['price']
      )
      p '!!! event_item:', event_item
      if event_item.valid? # => false
        p 'event_item is valid'
      else
        p 'event_item is invalid!'
      end

      # logの作成
      log = event_item.logs.create(event_item_id: event_item.id, diff_count: json_request['count'])

      render json: {items: Item.where(seller_id: seller.id)}
    end
  end

  def destroy
    item_id = params[:item_id]
    event_id = params[:event_id]
    r = EventItem.where(item_id: item_id, event_id: event_id).destroy_all
    if r.empty? # 削除するアイテムがなかったなら、202(accepted)を返す
      render status: :accepted
    else # アイテムが削除されたら、204(no_content)を返す
      render status: :no_content
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
end
