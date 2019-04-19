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

  context "Callbacks" do
    describe "#set_reference" do
      it { should callback(:set_reference).before(:create) }
    end

    it "should generate reference before creation" do
      batch = build(:batch)
      expect(batch.reference).to eq nil
      batch.save
      expect(batch.reference).not_to eq nil
    end
  end

end
