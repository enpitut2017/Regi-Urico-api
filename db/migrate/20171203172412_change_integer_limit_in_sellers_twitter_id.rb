class ChangeIntegerLimitInSellersTwitterId < ActiveRecord::Migration[5.1]
  def change
    change_column :sellers, :twitter_id, :integer, limit: 8
  end
end
