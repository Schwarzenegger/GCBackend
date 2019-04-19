require 'rails_helper'

describe API::V1::Batches, type: :request do
  let(:admin_user) { create(:admin_user) }

  context "POST" do
    describe "/" do
      it "Return return 400 if missing param" do
        post '/api/batches', params: {}

        expect(response.status).to eq(400)
      end

      it "Return forbidden if has no token" do
        post '/api/batches', params: { purchase_channel_id: 1 }

        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        post '/api/batches', params: { purchase_channel_id: 1 }, headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "return 400 if purchase channel has no ready order" do
        pc = create(:purchase_channel)
        post '/api/batches', params: {purchase_channel_id: pc.id }, headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body)['error']).to eq I18n.t('api.batches.invalid_pc')
      end

      it "Should Create a batch and send orders to production " do
        pc = create(:purchase_channel)
        new_order = create(:order, purchase_channel: pc)
        new_order_2 = create(:order, purchase_channel: pc)
        new_order_3 = create(:order)

        post '/api/batches', params: {purchase_channel_id: pc.id }, headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(201)
        batch_data = JSON.parse(response.body)["data"]
        expect(batch_data["relationships"]["orders"]["data"].count).to eq 2
      end
    end
  end
end
