class CreateEventItems < ActiveRecord::Migration[5.1]
  def change
    create_table :event_items do |t|
      t.integer :price
      t.reference :Item
      t.reference :Event

      t.timestamps
    end
  end
end
