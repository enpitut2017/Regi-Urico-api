class SellersAddPassword < ActiveRecord::Migration[5.1]
  def change
    add_column :sellers, :password_digest, :string
  end
end
