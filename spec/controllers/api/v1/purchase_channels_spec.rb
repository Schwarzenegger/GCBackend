require 'rails_helper'

describe API::V1::PurchaseChannels, type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:purchase_channel) { create(:purchase_channel) }

  describe "Get" do
    describe "/" do
       it "Return forbidden if has no token" do
        get '/api/purchase_channels'
        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        get '/api/purchase_channels', headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "Return all purchase channels" do
        pc = create(:purchase_channel)
        get '/api/purchase_channels', headers: mount_header(admin_user.access_token)
        pcs_data = JSON.parse(response.body)["data"]
        expect(pcs_data.length).to eq 1
        expect(response.status).to eq(200)
      end
    end

    describe "/:id" do
      it "Return forbidden if has no token" do
        get "/api/purchase_channels/#{purchase_channel.id}"
        expect(response.status).to eq(401)
      end
      it "Return forbidden if token is invalid" do
        get "/api/purchase_channels/#{purchase_channel.id}", headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end
      it "Return a specific purchase_channels" do
        get "/api/purchase_channels/#{purchase_channel.id}", headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(purchase_channel.id)
      end
    end
  end
end
