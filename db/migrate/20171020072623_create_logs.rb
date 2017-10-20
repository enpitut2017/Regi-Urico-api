class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.integer :diff_count
      t.references :event_items

      t.timestamps
    end
  end
end
