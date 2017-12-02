class EventItemsController < ApplicationController
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
end
