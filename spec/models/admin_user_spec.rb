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
    it { should respond_to(:created_at) }
    it { should respond_to(:updated_at) }
  end

  context "Validations" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

end
