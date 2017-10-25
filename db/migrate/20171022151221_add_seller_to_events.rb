class AddSellerToEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :seller, foreign_key: true
  end
end
