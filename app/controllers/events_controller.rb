class EventsController < ApplicationController
  def index
    seller = current_seller(request.headers['HTTP_X_AUTHRIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthrized' }
    else
      @events = seller.events
      render json: { event: @events }
    end
  end

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
