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
    json_request = JSON.parse(request.body.read)
    event_id = json_request['event_id']
    seller_id = json_request['seller_id']
    item_name = json_request['name']
    item = Item.new(name: item_name, seller_id: seller_id)
    EventItem.create(item: item, event_id: event_id) if item.save
  end
end
