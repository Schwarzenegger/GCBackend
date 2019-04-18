require 'rails_helper'

RSpec.describe Order, type: :model do
  it "should have a factory" do
    expect(FactoryBot.build(:order)).to be_valid
  end

  context "Should Respond" do
    it { should respond_to(:reference) }
    it { should respond_to(:purchase_channel_id) }
    it { should respond_to(:client_id) }
    it { should respond_to(:delivery_address) }
    it { should respond_to(:delivery_service) }
    it { should respond_to(:total_value) }
    it { should respond_to(:line_items) }
    it { should respond_to(:status) }
    it { should respond_to(:when_entered_production) }
    it { should respond_to(:finished_production) }
    it { should respond_to(:send_date) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  context "Associations" do
    it { should belong_to(:client) }
    it { should belong_to(:purchase_channel) }
  end

  context "Callbacks" do
    describe "#set_reference" do
      it { should callback(:set_reference).before(:create) }
    end

    it "should generate reference before creation" do
      order = build(:order)
      expect(order.reference).to eq nil
      order.save
      expect(order.reference).not_to eq nil
    end
  end

  context "Enums" do
     it { should define_enum_for(:delivery_service).with_values(
                                      pac: 1,
                                    sedex: 2,
                                  courier: 3) }

    it { should define_enum_for(:status).with_values(
                                    ready: 1,
                               production: 2,
                                  closing: 3,
                                     sent: 4) }

    describe "Status Enum States" do
      it "should start the production of a order" do
        order = FactoryBot.build(:order)
        expect(order.status).to eq "ready"
        expect(order.when_entered_production).to eq nil
        order.start_production
        expect(order.status).to eq "production"
        expect(order.when_entered_production).not_to eq nil
      end

      it "should finish priduction of a order" do
        order = FactoryBot.build(:order, status: "production", when_entered_production: DateTime.now)
        expect(order.status).to eq "production"
        expect(order.finished_production).to eq nil
        order.finish_product
        expect(order.status).to eq "closing"
        expect(order.finished_production).not_to eq nil
      end

      it "should mark order as sent" do
        order = FactoryBot.build(:order, status: "closing", finished_production: DateTime.now)
        expect(order.status).to eq "closing"
        expect(order.send_date).to eq nil
        order.deliver
        expect(order.status).to eq "sent"
        expect(order.send_date).not_to eq nil
      end
    end

  end

end
