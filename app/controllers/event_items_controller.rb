class EventItemsController < ApplicationController
  def create
    json_request = JSON.parse(request.body.read)
    item = Item.new(name: json_request['item_name'], seller_id: json_request['seller_id'])
    if item.valid?
      item.save
      event_item = EventItem.new(
        event_id: json_request['event_id'],
        item_id: item.id,
        price: json_request['price']
      )
      if event_item.valid?
        event_item.save
        log = event_item.logs.create(diff_count: json_request['count'])
      end
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

end
