require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    # it { should have_many... belong_to :example }
  end

  describe 'Validations' do
    subject(:user) { User.create!(email: 'example@example.com', password: 'password', password_confirmation: 'password', api_key: SecureRandom.uuid) }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
    it { should validate_presence_of :api_key }
    it { should validate_length_of(:api_key).is_equal_to 36 }
  end

  describe 'Model Methods' do
    it 'can create a new user with an api key' do
      user_params = { email: 'example@example.com', password: 'password', password_confirmation: 'password' }

      user = User.create_with_api_key(user_params)

      expect(user).to be_a(User)
      expect(user.email).to eq(user_params[:email])
      expect(user.password).to eq(user_params[:password])
      expect(user.api_key).to_not be_nil
      expect(user.api_key).to be_a(String)
      expect(user.api_key.length).to eq(36)
    end
  end
end