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
      event_items = EventItem.where(event_id: @event.id)
      items = []
      event_items.each do |event_item|
        item = Item.find_by(id: event_item.item_id)
        price = EventItem.find_by(item_id: item.id).price
        count = event_item.logs.sum(:diff_count)
        items.push({
            price: price,
            id: item.id,
            name: item.name,
            count: count,
            diff_count: 0,
         })
      end
      render json: { id: @event.id, name: @event.name, items: items }
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
    event = Event.find_by(id: json_request['id'])
    if event.nil?
      # event が存在しない場合
      return render json: { errors: { id: ['is not found'] } }, status: :not_found
    elsif event.seller != @seller
      # イベントの所有者以外が更新しようとしているので、403: Forbiddenを返す
      render json: { errors: { id: ['event is not yours'] }}, status: :forbidden
    else
      # イベントの所有者がトークンを持つカレントユーザと同一なので、更新を許可
      event.update(name: json_request['name'])
      if event.invalid?
        # 名前が空白など、データが不正な場合
        return render json: { errors: event.errors }, status: :bad_request
      else
        return render json: {
            id: event.id,
            name: event.name,
        }
      end
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
      if @event.nil?
        render status: :no_content
      else
        render json: {
            id: @event.id,
            name: @event.name,
        }
      end
    else
      # イベントの所有者以外が削除しようとしているので、403: Forbiddenを返す
      render json: { errors: { id: ['is forbidden'] }}, status: :forbidden
    end
  end

  def sales_log
    @event = Event.find_by(id: params[:id])
    if @event.nil?
      return render json: { errors: { id: ['is not found'] }}, status: :not_found
    elsif @event.seller == @seller
      # イベントの所有者はトークンを持つカレントユーザと同一なので、ログ出力を許可
      items = []
      sales = 0
      @event.event_items.each do |item|
        subcounts = -item.logs.where("diff_count < 0").sum(:diff_count)
        subsales = subcounts * item.price
        sales += subsales
        item = {
            id: item.id,
            subcount: subcounts,
            subsales: subsales
        }
        items.push(item)
      end
      return render json: { sales: sales, items: items }
    else
      # イベントの所有者以外がログ出力しようとしているので、403: Forbiddenを返す
      return render json: { errors: { id: ['is not yours'] }}, status: :forbidden
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