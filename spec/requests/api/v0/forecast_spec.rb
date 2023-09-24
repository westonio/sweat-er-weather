require 'rails_helper'

RSpec.describe 'Forcast Requests', type: :request do
  describe 'GET /api/v0/forecast?location=city,state', :vcr do
    context 'For a valid location' do
      it 'Returns the current, daily, and hourly weather' do
        location = "Denver,CO"

        get "/api/v0/forecast?location=#{location}"

        expect(response).to be_successful

        
        json = JSON.parse(response.body, symbolize_names: true)
        
        expect(json).to have_key(:data)
        expect(json[:data]).to be_a(Hash)
        expect(json[:data]).to have_key(:id)
        expect(json[:data][:id]).to be_nil
        expect(json[:data][:type]).to eq("forecast")
        expect(json[:data]).to have_key(:attributes)
        expect(json[:data][:attributes]).to be_a(Hash)

        attributes = json[:data][:attributes]

        expect(attributes).to have_key(:current)
        expect(attributes[:current]).to be_a(Hash)
        
        current = attributes[:current]
        current_keys = [:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition, :icon]
       
        expect(current.keys.count).to eq(8)
        expect(current.keys).to eq(current_keys)
        expect(current.values.count).to eq(8)

        expect(current[:last_updated]).to be_a(String)
        expect(current[:temperature]).to be_a(Float)
        expect(current[:feels_like]).to be_a(Float)
        expect(current[:humidity]).to be_a(Integer)
        expect(current[:uvi]).to be_a(Float)
        expect(current[:visibility]).to be_a(Float)
        expect(current[:condition]).to be_a(String)
        expect(current[:icon]).to be_a(String)

        expect(attributes).to have_key(:daily)
        expect(attributes[:daily]).to be_a(Array)
        expect(attributes[:daily].count).to eq(5)

        attributes[:daily].each do |day|
          day_keys = [:date, :sunrise, :sunset, :max_temp, :min_temp, :condition, :icon]

          expect(day.keys.count).to eq(7)
          expect(day.keys).to eq(day_keys)

          expect(day[:date]).to be_a(String)
          expect(day[:sunrise]).to be_a(String)
          expect(day[:sunset]).to be_a(String)
          expect(day[:max_temp]).to be_a(Float)
          expect(day[:min_temp]).to be_a(Float)
          expect(day[:condition]).to be_a(String)
          expect(day[:icon]).to be_a(String)
        end

        expect(attributes).to have_key(:hourly)
        expect(attributes[:hourly]).to be_a(Array)
        expect(attributes[:hourly].count).to eq(24)

        attributes[:hourly].each do |hour|
          hour_keys = [:time, :temperature, :condition, :icon]

          expect(hour.keys.count).to eq(4)
          expect(hour.keys).to eq(hour_keys)

          expect(hour[:time]).to be_a(String)
          expect(hour[:temperature]).to be_a(Float)
          expect(hour[:condition]).to be_a(String)
          expect(hour[:icon]).to be_a(String)
        end
      end
    end
  end
end