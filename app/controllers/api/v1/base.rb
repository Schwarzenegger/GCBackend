module API
  module V1
    class Base < Grape::API
      mount API::V1::PurchaseChannels
      mount API::V1::Orders
      mount API::V1::Clients
      mount API::V1::Batches
    end
  end
end
