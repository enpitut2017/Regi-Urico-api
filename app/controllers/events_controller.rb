class EventsController < ApplicationController
  def show
    @event = Event.find(params[:id])
    render json: @event, include: {event_items: :item}
  end
end
