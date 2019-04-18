require 'rails_helper'

describe API::V1::Clients, type: :request do
  let(:client) { create(:client) }

  describe "Get" do
    describe "/" do
      it "Return forbidden if has no token" do
        get '/api/clients/my_orders'
        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        get '/api/clients/my_orders', headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "should return the correct orders of a client" do
        new_order = create(:order, client: client)
        new_order_2 = create(:order, client: client)
        new_order_3 = create(:order)
        get '/api/clients/my_orders', headers: mount_header(client.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 2
        expect(response.status).to eq(200)
      end

      it "Should Paginate if has more than 10 records" do
        create_list(:order, 11, client: client)
        get '/api/clients/my_orders', headers: mount_header(client.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 10
        get '/api/clients/my_orders', params: { page: 2 }, headers: mount_header(client.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
      end
    end
  end
end
