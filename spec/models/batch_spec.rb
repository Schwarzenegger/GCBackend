require 'rails_helper'

RSpec.describe Batch, type: :model do
  it "should have a factory" do
    expect(FactoryBot.build(:batch)).to be_valid
  end

  context "Should Respond" do
    it { should respond_to(:reference) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  context "Associations" do
    it { should have_many(:orders) }
  end

end
