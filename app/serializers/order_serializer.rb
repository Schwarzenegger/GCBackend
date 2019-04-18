class OrderSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :reference, :purchase_channel_id, :client_id, :delivery_address,
             :delivery_service, :total_value, :line_items, :status,
             :when_entered_production, :finished_production, :send_date,
             :created_at, :updated_at
end
