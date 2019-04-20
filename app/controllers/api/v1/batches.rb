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

        desc "Close a batch"
        params do
          requires :id, type: Integer
        end
        put ":id/close" do
          authenticate_admin!
          batch = Batch.find(params[:id])
          orders_closed = []
          batch.orders.each do |order|
            if order.finish_product
              orders_closed << order
            end
          end

          render orders_closed
        end

        desc "Sent a batch to clients"
        params do
          requires :id, type: Integer
          requires :delivery_service, type: Integer
        end
        put ":id/sent" do
          authenticate_admin!
          orders_sent = []
          batch = Batch.find(params[:id])
          batch.orders.where(delivery_service: params[:delivery_service]).each do |order|
            if order.deliver
              orders_sent << order
            end
          end

          render orders_sent
        end
      end
    end
  end
end
