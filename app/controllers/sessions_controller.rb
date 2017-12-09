class SessionsController < ApplicationController
  def new
    @seller = Seller.find_by(name: login_params[:name])
    if @seller.nil?
      # 存在しない name を指定した場合
      render json: { errors: { 'name': ['is not found'] } }, status: :unauthorized
    elsif @seller.authenticate(login_params[:password])
      # 正しく認証できた場合
      render json: @seller
    else
      # password が誤っている場合
      render json: { errors: { 'password': ['does not match'] } }, status: :unauthorized
    end
  end

  private
  def login_params
    params.permit(:name, :password)
  end
end
