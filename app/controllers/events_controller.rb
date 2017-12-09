class EventsController < ApplicationController
  before_action :current_seller

  def index
    @events = @seller.events
    render json: { events: @events }
  end

  def create
    json_request = JSON.parse(request.body.read)
    @event = Event.create(
      name: json_request['name'],
      seller_id: @seller.id,
    )
    render json: {
      id: @event.id,
      name: @event.name,
    }
  end

  def update
    json_request = JSON.parse(request.body.read)
    @event = Event.find(json_request['id'])
    if @event.seller == @seller
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

  def destroy
    json_request = JSON.parse(request.body.read)
    @event = Event.find(json_request['id'])
    if @event.seller == @seller
      # イベントの所有者はトークンを持つカレントユーザと同一なので、削除を許可
      @event.destroy

      # 最後に更新されたイベントを返す
      @event = Event.order('updated_at desc').first
      if  @event.nil?
        render errors: 'No content', status: :no_content
      end

      render json: {
          id: @event.id,
          name: @event.name,
      }
    else
      # イベントの所有者以外が削除しようとしているので、403: Forbiddenを返す
      render status: :forbidden
    end
  end

  def show
    @event = Event.find_by(id: params[:id])
    if @event.nil?
      return render json: { errors: { event: ["is forbidden to access"] }}, status: :forbidden
    elsif @event.seller != seller
      render status: :forbidden
    else
      render json: @event, include: {event_items: :item}
    end

    id = params[:id]

    unless Seller.first.events.ids.include?(id)
      @event = Event.find_by(id: params[:id])
      if @event.nil?
        return render json: { errors: { event: ["is forbidden to access"] }}, status: :forbidden
      end
    end

    @event = Event.find(id)
    render json: @event, include: {event_items: :item}
  end

  private

  def current_seller()
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: { errors: { token: ["is unauthorized"] }}, status: :unauthorized
    end
  end
end