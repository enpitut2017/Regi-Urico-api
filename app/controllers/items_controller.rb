class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:id])
    render json: @item
  end

  def new
    @events = Event.all
    render json: @events.as_json(only: [:id, :name])
  end

  def create
    # TODO: 例外処理のフォーマットが決まったらそれに追従するようにエラー処理を書く
    json_request = JSON.parse(request.body.read)
    price = json_request['price']
    event_id = json_request['event_id']
    seller_id = json_request['seller_id']
    name = json_request['name']
    first_count = json_request['first_count']
    item = Item.create(name: name, seller_id: seller_id)
    event_item = EventItem.create(item: item, price: price, event_id: event_id)
    event_item.logs.create(diff_count: first_count)
  end
end
