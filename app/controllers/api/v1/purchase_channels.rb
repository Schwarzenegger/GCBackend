module API
  module V1
    class PurchaseChannels < API::V1::Base
      include API::V1::Defaults

      resource :purchase_channels do
        desc "Return all purchase channels"
        params do
          optional :page, type: Integer
        end
        get "/" do
          authenticate_admin!
          render PurchaseChannel.page(params[:page]).per(10)
        end

        desc "Return a specific purchase_channel"
        params do
          requires :id, type: Integer
        end
        get ":id" do
          authenticate_admin!
          render PurchaseChannel.find(params[:id])
        end
      end
    end
  end
end
