require 'rails_helper'

describe API::V1::Reports, type: :request do
  let(:admin_user) { create(:admin_user) }

  describe "Get" do
    describe "/simple_financial" do
      it "Return forbidden if has no token" do
        get '/api/reports/simple_financial'
        expect(response.status).to eq(401)
      end

      it "Return forbidden if token is invalid" do
        get '/api/reports/simple_financial', headers: { 'Authorization' => "Token token=asdadadssdas" }
        expect(response.status).to eq(401)
      end


      it "Return all purchase channels" do
        pc = create(:purchase_channel)
        pc_2 = create(:purchase_channel)
        new_order = create(:order, status: 1, purchase_channel: pc, total_value: 1.0)
        new_order_2 = create(:order, status: 1, purchase_channel: pc, total_value: 1.0)
        new_order_3 = create(:order, status: 1, purchase_channel: pc_2, total_value: 1.0)


        get '/api/reports/simple_financial', headers: mount_header(admin_user.access_token)
        expect(response.status).to eq(200)
        report_data = JSON.parse(response.body)

        pc_data = report_data.find {|x| x["name"] == pc.name}
        pc_2_data = report_data.find {|x| x["name"] == pc_2.name}

        expect(pc_data["value"]). to eq 2.0
        expect(pc_2_data["value"]). to eq 1.0
      end
    end
  end
end
