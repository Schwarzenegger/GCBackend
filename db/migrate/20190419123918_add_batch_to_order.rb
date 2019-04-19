class AddBatchToOrder < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :batch_id, :integer, index: true
  end
end
