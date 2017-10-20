class CreateEventItems < ActiveRecord::Migration[5.1]
  def change
    create_table :event_items do |t|
      t.integer :price
      t.references :item
      t.references :event

      t.timestamps
    end
  end
end
