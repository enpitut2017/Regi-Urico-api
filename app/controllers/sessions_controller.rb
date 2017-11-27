class SessionsController < ApplicationController
  def new
    @seller = Seller.find_by(name: login_params[:name])
    if @seller && @seller.authenticate(login_params[:password])
      render json: @seller
    else
      render json: { errors: @seller.errors.messages }
    end
  end

  private
  def login_params
    params.permit(:name, :password)
  end
end
