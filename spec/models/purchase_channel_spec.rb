require 'rails_helper'

RSpec.describe PurchaseChannel, type: :model do
  it "should have a factory" do
    expect(FactoryBot.build(:purchase_channel)).to be_valid
  end

  context "Should Respond" do
    it { should respond_to(:name) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  context "Validations" do
    it { should validate_presence_of(:name) }
  end
end

