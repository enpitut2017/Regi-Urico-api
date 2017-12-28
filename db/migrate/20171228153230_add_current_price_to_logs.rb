class AddCurrentPriceToLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :current_price, :integer
  end
end
