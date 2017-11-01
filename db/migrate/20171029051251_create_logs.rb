class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.references :event_item, foreign_key: true
      t.integer :diff_count

      t.timestamps
    end
  end
end
