class SellersAddtoken < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :token, :string
  end
end
