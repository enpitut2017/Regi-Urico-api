class SalesLogsController < ApplicationController
  before_action :current_seller

  def show
    event = Event.find_by(accept_params[:event_id])
    if event.nil?
      # 指定されたイベントが見つからない
      return render json: { errors: { id: ['is not found'] }}, status: :not_found
    elsif event.seller != @seller
      # イベントの所有者とトークンの所有者が異なる
      return render json: { errors: { id: ['is not yours'] }}, status: :forbidden
    else
      response = []
      event_sales_logs = event.sales_logs.order('created_at desc')
      if event_sales_logs.empty?
        # 指定したイベントの売上履歴が存在しない
        return render status: :no_content
      end
      sales_logs_by_day = event_sales_logs.group_by { |sales_log| sales_log.created_at.beginning_of_day }
      sales_logs_by_day.each do |date, sales_logs|
        receipts_array = []
        sales_logs.each do |sales_log|
          total = 0
          logs_array = []
          sales_log.logs.each do |log|
            count = -log.diff_count
            subtotal = (log.current_price || log.event_item.price) * count
            logs_array.push({ name: log.event_item.item.name, count: count, subtotal: subtotal })
            total += subtotal
          end
          receipts_array.push({
            id: sales_log.id,
            time: sales_log.created_at.to_datetime.to_s,
            formatted_time: sales_log.created_at.strftime('%H:%M:%S'),
            total: total,
            logs: logs_array,
          })
        end
        response.push({
          date: date.to_datetime.to_s,
          formatted_date: format_date(date.to_date),
          receipts: receipts_array,
        })
      end
      return render json: { sales_logs: response }
    end
  end

private

  def accept_params
    params.permit(:event_id)
  end

  def current_seller
    @seller = Seller.find_by(token: request.headers['HTTP_X_AUTHORIZED_TOKEN'])
    unless @seller
      render json: { errors: { token: ['is not authorized'] } }, status: :unauthorized
    end
  end

  def format_date(date)
    if date == Date.today
      'Today'
    elsif date == Date.yesterday
      'Yesterday'
    elsif date.year == Date.current.year
      date.strftime('%m/%d')
    else
      date.strftime('%Y/%m/%d')
    end
  end
end
