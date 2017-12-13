class EventsController < ApplicationController
  before_action :current_seller

  def index
    @events = @seller.events
    render json: { events: @events }
  end

  def show
    @event = Event.find_by(id: params[:id])
    if @event.nil?
      render json: { errors: {id: ['is not found'] }}, status: :not_found
    elsif @event.seller != @seller
      render json: { errors: { id: ['is not yours'] }}, status: :forbidden
    else
      render json: @event, include: {event_items: :item}
    end
  end

  def create
    json_request = JSON.parse(request.body.read)
    @event = Event.create(
        name: json_request['name'] || "",
        seller_id: @seller.id,
    )

    if @event.invalid?
      return render json: { errors: @event.errors.messages }, status: :bad_request
    end
    if @event.save
      return render json: { id: @event.id, name: @event.name }, status: :created
    else
      return render json: { errors: @event.errors.messages }, status: :bad_request
   end
  end

  def update
    json_request = JSON.parse(request.body.read)
    @event = Event.find(json_request['id'])
    if @event.seller == @seller
      # イベントの所有者はトークンを持つカレントユーザと同一なので、更新を許可
      @name = json_request['name']
      @event.update_attribute(:name, @name)
      if @name.nil? || @name.empty?
        return render json: { errors: { name: ['cannot be blank'] }}, status: :bad_request
      end
      render json: {
          id: @event.id,
          name: @event.name,
      }
    else
      # イベントの所有者以外が更新しようとしているので、403: Forbiddenを返す
      render json: { errors: { id: ['event is not yours'] }}, status: :forbidden
    end
  end

  def destroy
    json_request = JSON.parse(request.body.read)
    @event = Event.find_by(id: json_request['id'])
    if @event.nil?
      return render json: { errors: { id: ['is not found'] }}, status: :not_found
    end
    if @event.seller == @seller
      # イベントの所有者はトークンを持つカレントユーザと同一なので、削除を許可
      @event.destroy

      # 最後に更新されたイベントを返す
      @event = Event.order('updated_at desc').first

      render json: {
          id: @event.id,
          name: @event.name,
      }
    else
      # イベントの所有者以外が削除しようとしているので、403: Forbiddenを返す
      render json: { errors: { id: ['is forbidden'] }}, status: :forbidden
    end
  end

  def sales_log
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      @event = Event.find(params[:id])
      if @event.seller == seller
        # イベントの所有者はトークンを持つカレントユーザと同一なので、ログ出力を許可
        items = @event.event_items
        rets = []
        sales = 0
        items.each do |item|
          subcounts = -item.logs.where("diff_count < 0").sum(:diff_count)
          subsales = subcounts * item.price
          sales += subsales
          rets.push({
            id: item.id,
            subcount: subcounts,
            subsales: subsales
          })
        end
        return render json: {sales: sales, items: rets}
      else
        # イベントの所有者以外がログ出力しようとしているので、403: Forbiddenを返す
        render status: :forbidden
      end
    end
  end

  private

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: {errors: {token: ['is not authorized']}}, status: :unauthorized
    end
  end
end