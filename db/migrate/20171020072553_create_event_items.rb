class CreateEventItems < ActiveRecord::Migration[5.1]
  def change
    create_table :event_items do |t|
      t.integer :price
      t.references :Item
      t.references :Event

      t.timestamps
    end
  end
end
