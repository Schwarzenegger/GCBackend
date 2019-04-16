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
          render PurchaseChannel.page(params[:page]).per(10)
        end

      end
    end
  end
end
