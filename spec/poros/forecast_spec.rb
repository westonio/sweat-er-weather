require 'rails_helper'

RSpec.describe Forecast, type: :poro do
  describe 'Instance Methods', :vcr do
    let(:lat) { 39.74001 }
    let(:lon) { -104.99202 }
    let(:weather_data) { WeatherService.new(lat,lon).get_forecast }
    let(:forecast) { Forecast.new(weather_data) }

    let(:expected_current)  { {
                                :last_updated=>"2023-09-23 14:00",
                                :temperature=>72.0,
                                :feels_like=>71.9,
                                :humidity=>9,
                                :uvi=>6.0,
                                :visibility=>9.0,
                                :condition=>"Partly cloudy",
                                :icon=>"//cdn.weatherapi.com/weather/64x64/day/116.png"
                            } } 
    let(:expected_daily) { [
                            {:date=>"2023-09-23",
                              :sunrise=>"06:48 AM",
                              :sunset=>"06:56 PM",
                              :max_temp=>76.6,
                              :min_temp=>48.7,
                              :condition=>"Sunny",
                              :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                            {:date=>"2023-09-24",
                              :sunrise=>"06:49 AM",
                              :sunset=>"06:54 PM",
                              :max_temp=>78.6,
                              :min_temp=>48.6,
                              :condition=>"Sunny",
                              :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                            {:date=>"2023-09-25",
                              :sunrise=>"06:50 AM",
                              :sunset=>"06:52 PM",
                              :max_temp=>83.3,
                              :min_temp=>48.9,
                              :condition=>"Sunny",
                              :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                            {:date=>"2023-09-26",
                              :sunrise=>"06:51 AM",
                              :sunset=>"06:51 PM",
                              :max_temp=>84.6,
                              :min_temp=>53.8,
                              :condition=>"Sunny",
                              :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                            {:date=>"2023-09-27",
                              :sunrise=>"06:52 AM",
                              :sunset=>"06:49 PM",
                              :max_temp=>87.1,
                              :min_temp=>63.2,
                              :condition=>"Sunny",
                              :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"}
                        ] }
    let(:expected_hourly) { [
                              {:time=>"00:00", :temperature=>61.0, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"01:00", :temperature=>58.3, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"02:00", :temperature=>56.5, :condition=>"Cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/night/119.png"},
                              {:time=>"03:00", :temperature=>52.7, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"04:00", :temperature=>51.3, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/night/116.png"},
                              {:time=>"05:00", :temperature=>50.7, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/night/116.png"},
                              {:time=>"06:00", :temperature=>49.8, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"07:00", :temperature=>48.7, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"08:00", :temperature=>50.9, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/day/116.png"},
                              {:time=>"09:00", :temperature=>56.3, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"10:00", :temperature=>60.1, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"11:00", :temperature=>63.7, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"12:00", :temperature=>66.4, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/day/116.png"},
                              {:time=>"13:00", :temperature=>68.5, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"14:00", :temperature=>72.0, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/day/116.png"},
                              {:time=>"15:00", :temperature=>72.1, :condition=>"Partly cloudy", :icon=>"//cdn.weatherapi.com/weather/64x64/day/116.png"},
                              {:time=>"16:00", :temperature=>74.1, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"17:00", :temperature=>76.6, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"18:00", :temperature=>75.6, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"},
                              {:time=>"19:00", :temperature=>73.6, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"20:00", :temperature=>66.7, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"21:00", :temperature=>64.8, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"22:00", :temperature=>63.5, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"},
                              {:time=>"23:00", :temperature=>62.1, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"}
                          ] }

    it 'exists' do
      expect(forecast).to be_a(Forecast)
    end

    it 'has current weather data' do
      expect(forecast.current).to be_a(Hash)
      expect(forecast.current).to eq(expected_current)
    end

    it 'has daily weather data' do
      expect(forecast.daily).to be_an(Array)
      expect(forecast.daily).to eq(expected_daily)
      expect(forecast.daily.count).to eq(5)
      expect(forecast.daily.first).to be_a(Hash)
    end

    it 'has hourly weather data' do
      expect(forecast.hourly).to be_an(Array)
      expect(forecast.hourly).to eq(expected_hourly)
      expect(forecast.hourly.count).to eq(24)
      expect(forecast.hourly.first).to be_a(Hash)
    end

    it 'can format daily data' do
      day = {:date=>"2023-09-23",
            :date_epoch=>1695427200,
            :day=>
                  {:maxtemp_c=>24.8,
                    :maxtemp_f=>76.6,
                    :mintemp_c=>9.3,
                    :mintemp_f=>48.7,
                    :avgtemp_c=>16.8,
                    :avgtemp_f=>62.3,
                    :maxwind_mph=>11.9,
                    :maxwind_kph=>19.1,
                    :totalprecip_mm=>0.0,
                    :totalprecip_in=>0.0,
                    :totalsnow_cm=>0.0,
                    :avgvis_km=>10.0,
                    :avgvis_miles=>6.0,
                    :avghumidity=>40.0,
                    :daily_will_it_rain=>0,
                    :daily_chance_of_rain=>0,
                    :daily_will_it_snow=>0,
                    :daily_chance_of_snow=>0,
                    :condition=>{:text=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png", :code=>1000},
                    :uv=>5.0},
            :astro=>
                  {:sunrise=>"06:48 AM",
                    :sunset=>"06:56 PM",
                    :moonrise=>"03:41 PM",
                    :moonset=>"No moonset",
                    :moon_phase=>"Waxing Gibbous",
                    :moon_illumination=>"52",
                    :is_moon_up=>1,
                    :is_sun_up=>1}}

        expected = {:date=>"2023-09-23", :sunrise=>"06:48 AM", :sunset=>"06:56 PM", :max_temp=>76.6, :min_temp=>48.7, :condition=>"Sunny", :icon=>"//cdn.weatherapi.com/weather/64x64/day/113.png"}

        expect(forecast.send(:format_daily_weather, day)).to eq(expected)
    end

    it 'can format hourly data' do
      hour = {:time_epoch=>1695448800,
              :time=>"2023-09-23 00:00",
              :temp_c=>16.1,
              :temp_f=>61.0,
              :is_day=>0,
              :condition=>{:text=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png", :code=>1000},
              :wind_mph=>3.6,
              :wind_kph=>5.8,
              :wind_degree=>222,
              :wind_dir=>"SW",
              :pressure_mb=>1010.0,
              :pressure_in=>29.82,
              :precip_mm=>0.0,
              :precip_in=>0.0,
              :humidity=>33,
              :cloud=>0,
              :feelslike_c=>16.1,
              :feelslike_f=>61.0,
              :windchill_c=>16.1,
              :windchill_f=>61.0,
              :heatindex_c=>16.1,
              :heatindex_f=>61.0,
              :dewpoint_c=>-0.0,
              :dewpoint_f=>32.0,
              :will_it_rain=>0,
              :chance_of_rain=>0,
              :will_it_snow=>0,
              :chance_of_snow=>0,
              :vis_km=>10.0,
              :vis_miles=>6.0,
              :gust_mph=>6.3,
              :gust_kph=>10.2,
              :uv=>1.0}
      expected = {:time=>"00:00", :temperature=>61.0, :condition=>"Clear", :icon=>"//cdn.weatherapi.com/weather/64x64/night/113.png"}
      
      expect(forecast.send(:format_hourly_weather, hour)).to eq(expected)
    end

    it 'can convert date-time string to time' do
      expect(forecast.send(:format_time, "2023-09-23 01:00")).to eq("01:00")
    end
  end
end