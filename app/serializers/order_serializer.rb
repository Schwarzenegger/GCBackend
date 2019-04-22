class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :reference,:delivery_address,
             :delivery_service, :total_value, :line_items, :status,
             :when_entered_production, :finished_production, :send_date,
             :created_at, :updated_at

  belongs_to :client
  belongs_to :purchase_channel
  belongs_to :batch

end
