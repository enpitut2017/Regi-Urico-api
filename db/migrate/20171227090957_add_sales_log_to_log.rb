class AddSalesLogToLog < ActiveRecord::Migration[5.1]
  def change
    add_reference :logs, :sales_log, foreign_key: true
  end
end
