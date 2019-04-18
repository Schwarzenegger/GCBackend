module API
  module V1
    class Clients < API::V1::Base
      include API::V1::Defaults

      resource :clients do
        desc "Return all clients order"
        params do
          optional :page, type: Integer
        end
        get "/my_orders" do
          authenticate_client!
          render current_client.orders.order(created_at: :desc).page(params[:page]).per(10)
        end
      end
    end
  end
end
