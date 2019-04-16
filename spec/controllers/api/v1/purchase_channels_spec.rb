require 'rails_helper'
describe API::V1::PurchaseChannels, type: :request do
  describe "Get" do
    describe "/" do

      it "Return all purchase channels" do
        pc = create(:purchase_channel)
        get '/api/purchase_channels'
        pcs_data = JSON.parse(response.body)["data"]
        expect(pcs_data.length).to eq 1
        expect(response.status).to eq(200)
      end
    end
  end
end
