class ItemsController < ApplicationController
  def show
    @item = Item.find(params[:item_id])
    render json: @item
  end
end
