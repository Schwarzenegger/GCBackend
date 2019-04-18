require 'rails_helper'

describe API::V1::Orders, type: :request do
  let(:admin_user) { create(:admin_user) }
  let(:order) { create(:order) }

  describe "Get" do
    describe "/" do
      it "Return forbidden if has no token" do
        get '/api/orders'
        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        get '/api/orders', headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "Return all purchase channels" do
        order
        get '/api/orders', headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
      end

      it "Should Paginate if has more than 10 records" do
        create_list(:order, 11)
        get '/api/orders', headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 10
        get '/api/orders', params: { page: 2 }, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
      end

      it "Should be able to filter by purchase_channel" do
        pc = order.purchase_channel
        new_pc = create(:purchase_channel)
        get '/api/orders',params: { purchase_channel_id: pc.id}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
        get '/api/orders',params: { purchase_channel_id: new_pc.id}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 0
        expect(response.status).to eq(200)
      end

      it "Should be able to filter by status" do
        new_order = create(:order, status: 1)
        get '/api/orders',params: { status: 1}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
        get '/api/orders',params: { status: 2}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 0
        expect(response.status).to eq(200)
      end

      it "Should Filter by status and purchase_channel" do
        pc = create(:purchase_channel)
        new_order = create(:order, status: 1, purchase_channel: pc)
        new_order_2 = create(:order, status: 2, purchase_channel: pc)
        get '/api/orders',params: { status: 1, purchase_channel_id: pc.id}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.first["attributes"]["id"]).to eq new_order.id
        expect(order_data.length).to eq 1
        expect(response.status).to eq(200)
        get '/api/orders',params: { status: 2, purchase_channel_id: pc.id}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 1
        expect(order_data.first["attributes"]["id"]).to eq new_order_2.id
        expect(response.status).to eq(200)
      end

      it "Should Filter by client name" do
        client_1 = create(:client)
        client_2 = create(:client)

        new_order = create(:order, client: client_1)
        new_order_2 = create(:order, client: client_1)
        new_order_3 = create(:order, client: client_2)
        get '/api/orders',params: { client_name: client_1.name}, headers: mount_header(admin_user.access_token)
        order_data = JSON.parse(response.body)["data"]
        expect(order_data.length).to eq 2
        expect(response.status).to eq(200)
      end
    end

    describe "/:id" do
      it "Return forbidden if has no token" do
        get "/api/orders/#{order.id}"
        expect(response.status).to eq(401)
      end
      it "Return forbidden if token is invalid" do
        get "/api/orders/#{order.id}", headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end
      it "Return a specific order" do
        get "/api/orders/#{order.id}", headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(order.id)
      end
    end
  end

  context "POST" do
    describe "/" do

      it "Return return 400 if missing param" do
        post '/api/orders', params: {purchase_channel_id: 1, client_id: 1,
              delivery_address: "test address", delivery_service: 1, total_value: 123.0}

        expect(response.status).to eq(400)
      end

      it "Return forbidden if has no token" do
        post '/api/orders', params: {purchase_channel_id: 1, client_id: 1,
              delivery_address: "test address", delivery_service: 1, total_value: 123.0,
              line_items: [ {sky: 'New Case' }]}

        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        post '/api/orders', params: {purchase_channel_id: 1, client_id: 1,
              delivery_address: "test address", delivery_service: 1, total_value: 123.0,
              line_items: [ {sky: 'New Case' }]}, headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end

      it "should create order" do
        purchase_channel = create(:purchase_channel)
        client = create(:client)

        post '/api/orders', params: {purchase_channel_id: purchase_channel.id, client_id: client.id,
              delivery_address: "test address", delivery_service: 1, total_value: 123.0,
              line_items: [ {sky: 'New Case' }]}, headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body)['data']["attributes"]["id"]).to_not eq nil
      end
    end
  end
end
