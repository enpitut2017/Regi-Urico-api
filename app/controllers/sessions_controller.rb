class SessionsController < ApplicationController
  def new
    @seller = Seller.find_by(name: login_params[:name])
    if @seller.nil? || !@seller.authenticate(login_params[:password])
      # 存在しない name を指定した場合 または password が誤っている場合
      errors = {
          name: ["may be incorrect"],
          password: ["may be incorrect"],
      }
      render json: {errors: errors}, status: :unauthorized
    else
      # 正しく認証ができた場合
      render json: @seller
    end
  end

  private
  def login_params
    params.permit(:name, :password)
  end
end
