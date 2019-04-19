module API
  module V1
    class Batches < API::V1::Base
      include API::V1::Defaults

      resource :batches do

      desc "create a new batch"
      params do
        requires :purchase_channel_id, type: Integer
      end
      post "/" do
        authenticate_admin!
        orders = Order.where(purchase_channel_id: params[:purchase_channel_id]).ready
        if orders.empty?
          error!(I18n.t('api.batches.invalid_pc'), 400)
        else
          batch = Batch.create
          orders.each do |order|
            order.batch = batch
            order.start_production
          end

          render batch
        end
      end

      end
    end
  end
end
