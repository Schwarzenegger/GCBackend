require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  it "should have a factory" do
    expect(FactoryBot.build(:admin_user)).to be_valid
  end

  context "Should Respond" do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
    it { should respond_to(:reset_password_token) }
    it { should respond_to(:reset_password_sent_at) }
    it { should respond_to(:remember_created_at) }
    it { should respond_to(:access_token) }
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  context "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context "Callbacks" do
    describe "#generate_access_token" do
      it { should callback(:generate_access_token).before(:create) }
    end

    it "should generate access token before creation" do
      client = build(:client)
      expect(client.access_token).to eq nil
      client.save
      expect(client.access_token).not_to eq nil
    end
  end

end
