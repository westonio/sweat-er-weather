require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    # it { should have_many... belong_to :example }
  end

  describe 'Validations' do
    subject(:user) { User.create!(email: 'example@example.com', password: 'password', password_confirmation: 'password') }

    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of :password }
    it { should validate_confirmation_of :password }
  end
end