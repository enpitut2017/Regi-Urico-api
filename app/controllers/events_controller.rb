class EventsController < ApplicationController
  def create
    json_request = JSON.parse(request.body.read)
    Event.create(
      name: json_request['name'],
      seller_id: json_request['seller_id']
    )
  end

  def show
    @event = Event.find(params[:id])
    render json: @event, include: {event_items: :item}
  end
end
