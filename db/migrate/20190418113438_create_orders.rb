class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.string :reference
      t.references :purchase_channel, index: true
      t.references :client, index: true
      t.string :delivery_address
      t.integer :delivery_service
      t.float :total_value
      t.text :line_items, array: true
      t.integer :status, default: 1
      t.datetime :when_entered_production
      t.datetime :finished_production
      t.datetime :send_date

      t.timestamps
    end
  end
end
