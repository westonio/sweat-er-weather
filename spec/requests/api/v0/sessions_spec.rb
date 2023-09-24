require 'rails_helper'

RSpec.describe 'Session Requests', type: :request do
  describe 'POST /api/v0/sessions' do
    
    context 'With valid login credentials' do
      it 'starts a session and returns the email/ api_key for the user' do
        user = User.create!(email: "whatever@example.com", password: "password", password_confirmation: "password")
        params = {
          "email": "whatever@example.com",
          "password": "password"
        }
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/sessions', headers: headers, params: JSON.generate(params)

        expect(response).to be_successful

        json  = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)

        data = json[:data]

        expect(data).to have_key(:type)
        expect(data[:type]).to eq('users')

        expect(data).to have_key(:id)
        expect(data[:id]).to eq("#{user.id}")

        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]

        expect(attributes).to have_key(:email)
        expect(attributes[:email]).to be_a(String)
        expect(attributes).to have_key(:api_key)
        expect(attributes[:api_key]).to be_a(String)
      end
    end

    context 'With invalid login credentials' do

    end
  end
end