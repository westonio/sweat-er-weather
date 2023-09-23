require 'rails_helper'

RSpec.describe WeatherService, :vcr do
  describe 'based off of a latitude and longitude' do
    it 'returns the current weather data' do
      lat = 39.74001
      lon = -104.99202
      service = WeatherService.new(lat, lon)
      response = service.get_forecast

      expect(response).to have_key(:location)
      expect(response[:location]).to be_a(Hash)
      
      location = response[:location]

      expect(location).to have_key(:name)
      expect(location[:name]).to be_a(String)
      expect(location).to have_key(:region)
      expect(location[:region]).to be_a(String)
      expect(location).to have_key(:country)
      expect(location[:country]).to be_a(String)
      expect(location).to have_key(:lat)
      expect(location[:lat]).to be_a(Float)
      expect(location).to have_key(:lon)
      expect(location[:lon]).to be_a(Float)
      expect(location).to have_key(:localtime)
      expect(location[:localtime]).to be_a(String)

      expect(response).to have_key(:current)
      expect(response[:current]).to be_a(Hash)
      
      current = response[:current]

      expect(current).to have_key(:last_updated)
      expect(current[:last_updated]).to be_a(String)
      expect(current).to have_key(:temp_c)
      expect(current[:temp_c]).to be_a(Float)
      expect(current).to have_key(:temp_f)
      expect(current[:temp_f]).to be_a(Float)
      expect(current).to have_key(:is_day)
      expect(current[:is_day]).to be_an(Integer)

      expect(current).to have_key(:condition)
      expect(current[:condition]).to be_a(Hash)
      expect(current[:condition]).to have_key(:text)
      expect(current[:condition][:text]).to be_a(String)
      expect(current[:condition]).to have_key(:icon)
      expect(current[:condition][:icon]).to be_a(String)
      expect(current[:condition]).to have_key(:code)
      expect(current[:condition][:code]).to be_a(Integer)

      expect(current).to have_key(:wind_mph)
      expect(current[:wind_mph]).to be_a(Float)
      expect(current).to have_key(:wind_kph)
      expect(current[:wind_kph]).to be_a(Float)
      expect(current).to have_key(:wind_degree)
      expect(current[:wind_degree]).to be_a(Integer)
      expect(current).to have_key(:wind_dir)
      expect(current[:wind_dir]).to be_a(String)
      expect(current).to have_key(:pressure_mb)
      expect(current[:pressure_mb]).to be_a(Float)
      expect(current).to have_key(:pressure_in)
      expect(current[:pressure_in]).to be_a(Float)
      expect(current).to have_key(:precip_mm)
      expect(current[:precip_mm]).to be_a(Float)
      expect(current).to have_key(:precip_in)
      expect(current[:precip_in]).to be_a(Float)
      expect(current).to have_key(:humidity)
      expect(current[:humidity]).to be_a(Integer)
      expect(current).to have_key(:cloud)
      expect(current[:cloud]).to be_a(Integer)
      expect(current).to have_key(:feelslike_c)
      expect(current[:feelslike_c]).to be_a(Float)
      expect(current).to have_key(:feelslike_f)
      expect(current[:feelslike_f]).to be_a(Float)
      expect(current).to have_key(:vis_km)
      expect(current[:vis_km]).to be_a(Float)
      expect(current).to have_key(:vis_miles)
      expect(current[:vis_miles]).to be_a(Float)
      expect(current).to have_key(:uv)
      expect(current[:uv]).to be_a(Float)
      expect(current).to have_key(:gust_mph)
      expect(current[:gust_mph]).to be_a(Float)
      expect(current).to have_key(:gust_kph)
      expect(current[:gust_kph]).to be_a(Float)
    end

    it 'returns the necessary weather data for the next 5 days' do
      lat = 39.74001
      lon = -104.99202
      service = WeatherService.new(lat, lon)
      response = service.get_forecast

      expect(response).to have_key(:location)
      expect(response[:location]).to be_a(Hash)
      
      location = response[:location]

      expect(location).to have_key(:name)
      expect(location[:name]).to be_a(String)
      expect(location).to have_key(:region)
      expect(location[:region]).to be_a(String)
      expect(location).to have_key(:country)
      expect(location[:country]).to be_a(String)
      expect(location).to have_key(:lat)
      expect(location[:lat]).to be_a(Float)
      expect(location).to have_key(:lon)
      expect(location[:lon]).to be_a(Float)
      expect(location).to have_key(:localtime)
      expect(location[:localtime]).to be_a(String)

      expect(response).to have_key(:forecast)
      expect(response[:forecast]).to be_a(Hash)

      forecast = response[:forecast]

      expect(forecast).to have_key(:forecastday)
      expect(forecast[:forecastday]).to be_an(Array)
      expect(forecast[:forecastday].count).to eq(5)

      forecast[:forecastday].each do |day|
        expect(day).to have_key(:date)
        expect(day[:date]).to be_a(String)

        expect(day).to have_key(:day)
        expect(day[:day]).to be_a(Hash)

        day_temp = day[:day]

        expect(day_temp).to have_key(:maxtemp_f)
        expect(day_temp[:maxtemp_f]).to be_a(Float)
        expect(day_temp).to have_key(:mintemp_f)
        expect(day_temp[:mintemp_f]).to be_a(Float)
        expect(day_temp).to have_key(:avgtemp_f)
        expect(day_temp[:avgtemp_f]).to be_a(Float)
        expect(day_temp).to have_key(:avgtemp_f)
        expect(day_temp[:avgtemp_f]).to be_a(Float)

        expect(day_temp).to have_key(:condition)
        expect(day_temp[:condition]).to be_a(Hash)
        expect(day_temp[:condition]).to have_key(:text)
        expect(day_temp[:condition][:text]).to be_a(String)
        expect(day_temp[:condition]).to have_key(:icon)
        expect(day_temp[:condition][:icon]).to be_a(String)
        expect(day_temp[:condition]).to have_key(:code)
        expect(day_temp[:condition][:code]).to be_a(Integer)

        expect(day).to have_key(:astro)
        expect(day[:astro]).to be_a(Hash)

        astro = day[:astro]

        expect(astro).to have_key(:sunrise)
        expect(astro[:sunrise]).to be_a(String)
        expect(astro).to have_key(:sunset)
        expect(astro[:sunset]).to be_a(String)
      end
    end
    
    it 'returns the necessary hourly weather data for the current day' do
      lat = 39.74001
      lon = -104.99202
      service = WeatherService.new(lat, lon)
      response = service.get_forecast

      expect(response).to have_key(:location)
      expect(response[:location]).to be_a(Hash)
      
      location = response[:location]

      expect(location).to have_key(:name)
      expect(location[:name]).to be_a(String)
      expect(location).to have_key(:region)
      expect(location[:region]).to be_a(String)
      expect(location).to have_key(:country)
      expect(location[:country]).to be_a(String)
      expect(location).to have_key(:lat)
      expect(location[:lat]).to be_a(Float)
      expect(location).to have_key(:lon)
      expect(location[:lon]).to be_a(Float)
      expect(location).to have_key(:localtime)
      expect(location[:localtime]).to be_a(String)

      expect(response).to have_key(:forecast)
      expect(response[:forecast]).to be_a(Hash)

      forecast = response[:forecast]

      expect(forecast).to have_key(:forecastday)
      expect(forecast[:forecastday]).to be_an(Array)
      expect(forecast[:forecastday].count).to eq(5)

      day = forecast[:forecastday].first
      expect(day).to have_key(:date)
      expect(day[:date]).to be_a(String)
      
      expect(day).to have_key(:hour)
      expect(day[:hour]).to be_an(Array)
      expect(day[:hour].count).to eq(24)

      day[:hour].each do |hour|
        expect(hour).to have_key(:time)
        expect(hour[:time]).to be_a(String)
        expect(hour).to have_key(:temp_f)
        expect(hour[:temp_f]).to be_a(Float)

        expect(hour).to have_key(:condition)
        expect(hour[:condition]).to be_a(Hash)
        expect(hour[:condition]).to have_key(:text)
        expect(hour[:condition][:text]).to be_a(String)
        expect(hour[:condition]).to have_key(:icon)
        expect(hour[:condition][:icon]).to be_a(String)
        expect(hour[:condition]).to have_key(:code)
        expect(hour[:condition][:code]).to be_a(Integer)
      end
    end
  end
end