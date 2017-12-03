class EventsController < ApplicationController
  def index
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized' }
    else
      @events = seller.events
      render json: { event: @events }
    end
  end

  def create
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.create(
          name: json_request['name'],
          seller_id: seller.id,
      )
      render json: {
          id: @event.id,
          name: @event.name,
      }
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
