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

  end
end
