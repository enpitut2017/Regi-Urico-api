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

  def update
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.find(json_request['event_id'])
      @event.update_attribute(:name, json_request['name'])
      render json: {
          id: @event.id,
          name: @event.name,
      }
    end
  end

  def destroy
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.find(json_request['event_id'])
      @event.destroy

      # 最後に更新されたイベントを返す
      @event = Event.order('updated_at desc').first

      render json: {
          id: @event.id,
          name: @event.name,
      }
    end
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
