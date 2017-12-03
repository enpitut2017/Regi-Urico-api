class SessionsController < ApplicationController
  def new
    @seller = Seller.find_by(name: login_params[:name])
    if @seller && @seller.authenticate(login_params[:password])
      render json: {
          id: @seller.id,
          token: @seller.token,
          name: @seller.name,
          twitter_name: @seller.twitter_name,
          twitter_screen_name: @seller.twitter_screen_name,
          twitter_image_url: @seller.twitter_image_url,
      }
    else
      render json: {errors: @seller.errors.messages}
    end
  end

  def callback
    current_seller
    render json: {errors: 'Unauthorized'}, status: :unauthorized unless @seller
    auth = auth_hash
    twitter_info = {
        twitter_token: auth.credentials.token,
        twitter_secret: auth.credentials.secret,
        twitter_id: auth.uid,
        twitter_name: auth.info.name,
        twitter_screen_name: auth.info.nickname,
        twitter_image_url: auth.info.image.sub('_normal', ''),
    }
    @seller.update(twitter_info)
    p @seller
    redirect_to back_to || '/'
  end

  private

  def login_params
    params.permit(:name, :password)
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: {errors: 'Unauthorized'}, status: :unauthorized
    end
  end

  def back_to
    if request.env['omniauth.origin'].presence && back_to = CGI.unescape(request.env['omniauth.origin'].to_s)
      uri = URI.parse(back_to)
      return back_to if uri.relative? || uri.host == request.host
    end
    nil
  rescue
    nil
  end
end
