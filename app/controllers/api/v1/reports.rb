module API
  module V1
    class Reports < API::V1::Base
      include API::V1::Defaults
      resource :reports do
        desc "Simple Financial Report"
        get "/simple_financial" do
          authenticate_admin!
          report =  []
          PurchaseChannel.all.each do |pc|
            report << { name: pc.name, value: pc.orders.sum(:total_value) }
          end
          render report
        end
      end
    end
  end
end
