require 'rails_helper'

RSpec.describe WeatherFacade, type: :facade do
  describe 'Instance Methods' do
    let(:location) { "Paris,France" }
    let(:facade) { WeatherFacade.new(location) }

    it 'exists' do
      expect(facade).to be_a(WeatherFacade)
    end

    it 'initializes with a location' do
      expect(facade.location).to eq(location)
    end

    it 'does not initially have latitude and longitude' do
      expect(facade.latitude).to be_nil
      expect(facade.longitude).to be_nil
    end

    it 'can find the latitude and longitude', :vcr do
      facade.send(:find_lat_lon)

      expect(facade.latitude).to eq(48.85717)
      expect(facade.longitude).to eq(2.3414)
    end

    it 'can create the forecasted weather object', :vcr do
      expect(facade.forecast).to be_a(Forecast)
    end
  end
end