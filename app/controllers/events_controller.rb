class EventsController < ApplicationController
  def index
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized' }
    else
      @events = seller.events
      render json: { event: @events }
    end
  end

  def create
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.create(
          name: json_request['name'],
          seller_id: seller.id,
      )
      render json: {
          id: @event.id,
          name: @event.name,
      }
    end
  end

  def update
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.find(json_request['event_id'])
      if @event.seller == seller
        # イベントの所有者はトークンを持つカレントユーザと同一なので、更新を許可
        @event.update_attribute(:name, json_request['name'])
        render json: {
            id: @event.id,
            name: @event.name,
        }
      else
        # イベントの所有者以外が更新しようとしているので、403: Forbiddenを返す
        render status: :forbidden
      end
    end
  end

  def destroy
    seller = current_seller(request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless seller
      render json: { errors: 'Unauthorized'}
    else
      json_request = JSON.parse(request.body.read)
      @event = Event.find(json_request['event_id'])
      if @event.seller == seller
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
        render status: :forbidden
      end
    end
  end

  def show
    @event = Event.find(params[:id])
    render json: @event, include: {event_items: :item}
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

  def current_seller(token)
    seller = Seller.find_by(token: token)
    if seller
      seller
    else
      false
    end
  end
end
