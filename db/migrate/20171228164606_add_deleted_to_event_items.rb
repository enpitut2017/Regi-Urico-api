class AddDeletedToEventItems < ActiveRecord::Migration[5.1]
  def change
    add_column :event_items, :deleted, :boolean, default: false
  end
end
