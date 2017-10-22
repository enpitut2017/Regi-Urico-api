class EventsController < ApplicationController
  def show
    @event = Event.find(params[:event_id])
    render json: @event, include: {event_items: :item}
  end
end
