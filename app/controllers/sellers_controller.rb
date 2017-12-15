class SellersController < ApplicationController
  before_action :current_seller, only: [:update, :destroy]

  def create
    @seller = Seller.new(seller_params)
    if @seller.valid?
      @seller.save
      render json: @seller, status: :created
    else
      render json: { errors: @seller.errors.messages }, status: :bad_request
    end
  end

  def update
    new_name = seller_params[:name]
    new_password = seller_params[:password]
    if @seller.update_attributes(
      name: (new_name.blank?) ? @seller.name : new_name,
      password: new_password || "",
      password_confirmation: new_password || ""
    ) then
      # 更新成功
      render json: @seller
    else
      # バリデーションエラー
      # password_digestはいらないのでフィルタする
      render json: { errors: @seller.errors.messages.select{|k, v| k != :password_digest} }, status: :bad_request
    end
  end

  def destroy
    if @seller.authenticate(seller_params[:password])
      @seller.events.each do |event|
        event.event_items.destroy_all
      end
      @seller.events.destroy_all
      @seller.items.destroy_all
      @seller.destroy
      render status: :no_content
    else
      render json: { errors: {password: ['is incorrect']} }, status: :bad_request
    end
  end

  private

  def seller_params
    params.permit(:name, :password, :password_confirmation)
  end

  def current_seller
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: { errors: {token: ['is unauthorized']} }, status: :unauthorized
    end
  end
end
