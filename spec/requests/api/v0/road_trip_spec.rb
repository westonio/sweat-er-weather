require 'rails_helper'

RSpec.describe 'Session Requests', type: :request do
  describe 'POST /api/v0/road_trip', :vcr do
    context 'with achieveable routes and valid API key' do
      it 'returns the road-trip info and weather at ETA' do
        user = User.create!(email: "myemail@example.com", password: "password", password_confirmation: "password")
        params = {
          origin: "Cincinatti,OH",
          destination: "Chicago,IL",
          api_key: user.api_key
        }
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/road_trip', headers: headers, params: JSON.generate(params)

        expect(response).to be_successful

        json  = JSON.parse(response.body, symbolize_names: true)


        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)

        data = json[:data]

        expect(data).to have_key(:id)
        expect(data[:id]).to be_nil

        expect(data).to have_key(:type)
        expect(data[:type]).to eq('road_trip')
        
        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]

        expect(attributes).to have_key(:start_city)
        expect(attributes[:start_city]).to be_a(String)
        expect(attributes[:start_city]).to eq("Cincinatti,OH")
        
        expect(attributes).to have_key(:end_city)
        expect(attributes[:end_city]).to be_a(String)
        expect(attributes[:end_city]).to eq("Chicago,IL")
        
        expect(attributes).to have_key(:travel_time)
        expect(attributes[:travel_time]).to be_a(String)
        
        expect(attributes).to have_key(:weather_at_eta)
        expect(attributes[:weather_at_eta]).to be_a(Hash)

        weather = attributes[:weather_at_eta]

        expect(weather).to have_key(:datetime)
        expect(weather[:datetime]).to be_a(String)

        expect(weather).to have_key(:temperature)
        expect(weather[:temperature]).to be_a(Float)

        expect(weather).to have_key(:condition)
        expect(weather[:condition]).to be_a(String)
      end
    end

    context 'with an invalid api_key' do
      it 'returns an error' do
        User.create!(email: "myemail@example.com", password: "password", password_confirmation: "password")
        params = {
          origin: "Cincinatti,OH",
          destination: "Chicago,IL",
          api_key: "Invalid-Key"
        }
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/road_trip', headers: headers, params: JSON.generate(params)

        expect(response).to_not be_successful
        expect(response).to have_http_status(:unauthorized)

        json = JSON.parse(response.body, symbolize_names: true)

        expect(json).to have_key(:errors)
        expect(json[:errors]).to have_key(:details)
        expect(json[:errors][:details]).to eq("Invalid Api Key")
      end
    end

    context 'with unachieveable routes' do
      it 'returns "impossible" and an empty weather hash' do
        user = User.create!(email: "myemail@example.com", password: "password", password_confirmation: "password")
        params = {
          origin: "Cincinatti, OH",
          destination: "Taipei, Taiwan",
          api_key: user.api_key
        }
        headers = {"CONTENT_TYPE" => "application/json"}

        post '/api/v0/road_trip', headers: headers, params: JSON.generate(params)

        expect(response).to be_successful

        json  = JSON.parse(response.body, symbolize_names: true)
        
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)

        data = json[:data]

        expect(data).to have_key(:id)
        expect(data[:id]).to be_nil

        expect(data).to have_key(:type)
        expect(data[:type]).to eq('road_trip')
        
        expect(data).to have_key(:attributes)
        expect(data[:attributes]).to be_a(Hash)

        attributes = data[:attributes]

        expect(attributes).to have_key(:start_city)
        expect(attributes[:start_city]).to be_a(String)
        expect(attributes[:start_city]).to eq("Cincinatti, OH")
        
        expect(attributes).to have_key(:end_city)
        expect(attributes[:end_city]).to be_a(String)
        expect(attributes[:end_city]).to eq("Taipei, Taiwan")
        
        expect(attributes).to have_key(:travel_time)
        expect(attributes[:travel_time]).to eq("Impossible")
        
        expect(attributes).to have_key(:weather_at_eta)
        expect(attributes[:weather_at_eta]).to be_a(Hash)
        expect(attributes[:weather_at_eta]).to be_empty
      end
    end
  end
end