class EventItemsController < ApplicationController
  def destroy
    item_id = params[:item_id]
    event_id = params[:event_id]
    r = EventItem.where(item_id: item_id, event_id: event_id).destroy_all
    if r.empty? # 削除するアイテムがなかったなら、202(accepted)を返す
      render status: :accepted
    else # アイテムが削除されたら、204(no_content)を返す
      render status: :no_content
    end
  end
end
