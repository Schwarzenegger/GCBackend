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

  context "PUT" do
    describe ":id/close" do
      it "Return forbidden if has no token" do
        put '/api/batches/1/close'

        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        put '/api/batches/1/close', headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "should rescue from cant find id" do
        put '/api/batches/12312321312/close', headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(404)
      end

      it "Should close orders from a batch" do
        new_batch = create(:batch)
        pc = create(:purchase_channel)

        new_order = create(:order, purchase_channel: pc, status: 2, batch: new_batch)
        new_order_2 = create(:order, purchase_channel: pc, status: 2, batch: new_batch)

        put "/api/batches/#{new_batch.id}/close", headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(200)
        new_order.reload
        new_order_2.reload
        expect(new_order.status).to eq "closing"
        expect(new_order_2.status).to eq "closing"
      end
    end

    describe ":id/sent" do
      it "Return forbidden if has no token" do
        put '/api/batches/1/sent', params: { delivery_service: 1 }

        expect(response.status).to eq(401)
      end

      it "Return return 400 if missing param" do
        put '/api/batches/1/sent', params: {}

        expect(response.status).to eq(400)
      end

      it "Return forbidden if token is invalid" do
        put '/api/batches/1/sent', params: { delivery_service: 1 }, headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "should rescue from cant find id" do
        put '/api/batches/12312321312/sent', params: { delivery_service: 1 }, headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(404)
      end

      it "Should sent orders from a batch to clients with chosen delivery service" do
        new_batch = create(:batch)
        pc = create(:purchase_channel)

        new_order = create(:order, purchase_channel: pc, status: 3, batch: new_batch, delivery_service: 1)
        new_order_2 = create(:order, purchase_channel: pc, status: 3, batch: new_batch, delivery_service: 1)
        new_order_3 = create(:order, purchase_channel: pc, status: 3, batch: new_batch, delivery_service: 2)

        put "/api/batches/#{new_batch.id}/sent", params: { delivery_service: 1 }, headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(200)
        new_order.reload
        new_order_2.reload
        new_order_3.reload
        expect(new_order.status).to eq "sent"
        expect(new_order_2.status).to eq "sent"
        expect(new_order_3.status).to eq "closing"
      end
    end
  end
end
