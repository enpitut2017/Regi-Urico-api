class SellersController < ApplicationController
  def create
    @seller = Seller.new(seller_params)
    if @seller.valid?
      @seller.save
      render json: @seller, status: :created
    else
      render json: { errors: @seller.errors.messages }, status: :bad_request
    end
  end

  private

  def seller_params
    params.permit(:name, :password, :password_confirmation)
  end
end
