ActiveAdmin.register Order do
  menu priority: 1

  actions  :index, :edit, :show, :update

  permit_params :purchase_channel_id, :client_id, :delivery_address, :delivery_service,
                :total_value, :line_items_raw

  filter :purchase_channel
  filter :client
  filter :delivery_service

  includes :client, :purchase_channel

  index do
    selectable_column
    id_column
    column :purchase_channel
    column :client
    column :status
    column :delivery_service
    column :delivery_address
    column :total_value

    actions
  end

  form do |f|
    f.inputs do
      f.input :purchase_channel
      f.input :client
      f.input :delivery_address
      f.input :delivery_service
      f.input :total_value
      f.input :line_items_raw
    end
    f.actions
  end

end
