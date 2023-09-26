require 'rails_helper'

RSpec.describe RoadTrip, type: :poro do
  describe 'Instance Methods', :vcr do
    let(:origin) { "Denver, CO" } 
    let(:destination) { "New York, NY" } 
    let(:invalid_destination) { "Taipei, Taiwan" }

    let(:valid_trip) { {:sessionId=>"ANIA5wcAAAUBAAAHAAAABQAAAHwBAAB42mOoYWRgZGJgYGDPSC1KtUrOFeU0lmZgYGBQMNm-g8PqZJjppiKnGBC9ucgphgELgGnsn1QmCeJ_TresZ7LKiveef-tzjE9WvPeOW5-xagQB114zxj3sDAwMLrKMTSGMDAcEBGBSLAwMDhjqmXCYw8TAwiDAxMAIV-QANwQFNEAMaGBDCCkgTBYA6WKEijswMEDdwohpnwDCYA6EuxzQXakgCJGHeUqBCWKdQJCJQAODcSgLAC7BI9HP1DL6:car",
                        :realTime=>91555,
                        :distance=>1780.3931,
                        :time=>89732,
                        :formattedTime=>"24:55:32",
                        :hasHighway=>true,
                        :hasTollRoad=>true,
                        :hasBridge=>true,
                        :hasSeasonalClosure=>false,
                        :hasTunnel=>true,
                        :hasFerry=>false,
                        :hasUnpaved=>false,
                        :hasTimedRestriction=>false,
                        :hasCountryCross=>false } }
    let(:invalid_trip) { {:routeError=>{:errorCode=>2, :message=>""}} }
    let(:forecast) { WeatherFacade.new(destination).forecast }
    
    
    it 'exists' do
      rt = RoadTrip.new(origin, destination, valid_trip, forecast)
      
      expect(rt).to be_a(RoadTrip)
    end

    it 'has a start city, end city' do
      rt = RoadTrip.new(origin, destination, valid_trip, forecast)
      
      expect(rt.start_city).to eq(origin)
      expect(rt.end_city).to eq(destination)
    end

    it 'has travel time from data' do 
      rt = RoadTrip.new(origin, destination, valid_trip, forecast)
      
      expect(rt.travel_time).to eq("24:55:32")
    end

    it 'can find weather at ETA' do
      rt = RoadTrip.new(origin, destination, valid_trip, forecast)
     
      expect(rt.weather_at_eta).to be_a(Hash)
      expect(rt.weather_at_eta[:datetime]).to be_a(String)
      expect(rt.weather_at_eta[:temperature]).to be_a(Float)
      expect(rt.weather_at_eta[:condition]).to be_a(String)
    end

    it 'if travel not possible, time is "Impossible" and weather at ETA is empty' do 
      rt = RoadTrip.new(origin, destination, invalid_trip, forecast)
      
      expect(rt.travel_time).to eq("Impossible")
      expect(rt.weather_at_eta).to eq({})
    end
  end
end