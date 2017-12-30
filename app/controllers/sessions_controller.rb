class SessionsController < ApplicationController
  #before_action :current_seller, only: [:setup]

  def new
    seller = Seller.find_by(name: login_params[:name])
    if seller.nil? || ! seller.authenticate(login_params[:password])
      # 存在しない name を指定した場合 または password が誤っている場合
      errors = {
          name: ["may be incorrect"],
          password: ["may be incorrect"],
      }
      render json: {errors: errors}, status: :unauthorized
    else
      # 正しく認証ができた場合
      render json: seller
    end
  end

  def setup
  end

  def callback
    auth = auth_hash()
    twitter_info = {
        twitter_token: auth.credentials.token,
        twitter_secret: auth.credentials.secret,
        twitter_id: auth.uid,
        twitter_name: auth.info.name,
        twitter_screen_name: auth.info.nickname,
        twitter_image_url: auth.info.image.sub('_normal', ''),
    }
    seller_id = auth_params[:seller_id]
    if seller_id
      Seller.find_by(id: seller_id).update(twitter_info)
      redirect_to back_to || '/'
    else
      render json: { errors: { seller_id: ['is not found'] } }, status: :bad_request
    end
  end

  private

  def login_params
    params.permit(:name, :password)
  end

  def auth_params
    params.permit(:seller_id, :oauth_token, :oauth_verifier, :provider)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def current_seller
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: { errors: { token: ['is not authorized'] }}, status: :unauthorized
    end
  end

  def back_to
    if request.env['omniauth.origin'].presence && back_to = CGI.unescape(request.env['omniauth.origin'].to_s)
      uri = URI.parse(back_to)
      return (uri.relative? || uri.host == request.host) ? back_to : nil
    end
  rescue
    nil
  end
end
