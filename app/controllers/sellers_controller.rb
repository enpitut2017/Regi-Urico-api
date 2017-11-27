class SellersController < ApplicationController
  def create
    @seller = Seller.new(seller_params)
    if @seller.valid?
      @seller.save
      render json: @seller
    else
      render json: { errors: @seller.errors.messages }
    end
  end

  private

  def seller_params
    params.permit(:name, :password, :password_confirmation)
  end
end
