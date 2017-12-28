class CreateSalesLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :sales_logs do |t|
      t.references :event, foreign_key: true
      t.integer :deposit

      t.timestamps
    end
  end
end
