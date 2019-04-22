module API
  module V1
    class Orders < API::V1::Base
      include API::V1::Defaults

      resource :orders do
        desc "Return all orders or search by purchase_channel, status and/or client name"
        params do
          optional :page, type: Integer
          optional :purchase_channel_id, type: Integer
          optional :status, type: Integer
          optional :client_name, type: String
        end
        get "/" do
          authenticate_admin!

          orders = Order.by_purchase_channel(params[:purchase_channel_id]).by_status(params[:status])
          if params[:client_name]
            orders = orders.ransack(client_name_eq: params[:client_name]).result
          end

          render orders.page(params[:page]).per(10)
        end

        desc "Return a specific order"
        params do
          requires :id, type: Integer
        end
        get ":id" do
          authenticate_admin!
          render Order.find(params[:id])
        end

        desc "create a new order"
        params do
          requires :purchase_channel_id, type: Integer
          requires :client_id, type: Integer
          requires :delivery_address, type: String
          requires :delivery_service, type: Integer
          requires :total_value, type: Float
          requires :line_items, type: Array
        end
        post "/" do
          authenticate_admin!
          new_order = Order.create(params)
          render new_order
        end

        desc "Edit a order"
        params do
          requires :id, type: Integer
          optional :delivery_address, type: String
          optional :delivery_service, type: Integer
          optional :total_value, type: Float
          optional :line_items, type: Array
        end
        put ":id" do
          authenticate_admin!
          order = Order.find(params[:id])
          order.update_attributes(params)
          render order
        end
      end
    end
  end
end
