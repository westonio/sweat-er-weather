require 'rails_helper'

RSpec.describe MapquestService, :vcr do
  it 'returns the latitude and longitude for a given city,state' do
    location = "Denver,CO"
    service = MapquestService.new
    response = service.get_lat_lon(location)
    results = response[:results].first
    
    expect(results).to be_an(Hash)
    expect(results).to have_key(:providedLocation)
    expect(results[:providedLocation]).to be_a(Hash)
    expect(results[:providedLocation]).to have_key(:location)
    expect(results[:providedLocation][:location]).to eq(location)

    expect(results).to have_key(:locations)
    expect(results[:locations]).to be_an(Array)
    
    results[:locations].each do |location|
      expect(location).to have_key(:adminArea5)
      expect(location[:adminArea5]).to be_a(String)
      expect(location[:adminArea5]).to eq("Denver")
      
      expect(location).to have_key(:adminArea3)
      expect(location[:adminArea3]).to be_a(String)
      expect(location[:adminArea3]).to eq("CO")

      expect(location).to have_key(:latLng)
      expect(location[:latLng]).to be_a(Hash)
      expect(location[:latLng]).to have_key(:lat)
      expect(location[:latLng][:lat]).to be_a(Float)
      expect(location[:latLng]).to have_key(:lng)
      expect(location[:latLng][:lng]).to be_a(Float)

      expect(location).to have_key(:displayLatLng)
      expect(location[:displayLatLng]).to be_a(Hash)
      expect(location[:displayLatLng]).to have_key(:lat)
      expect(location[:displayLatLng][:lat]).to be_a(Float)
      expect(location[:displayLatLng]).to have_key(:lng)
      expect(location[:displayLatLng][:lng]).to be_a(Float)
    end
  end

  context 'it returns the directions for a given origin and destination' do
    it 'has the necessary time information for valid locations' do
      origin = "Denver, CO" 
      destination = "New York, NY" 
      service = MapquestService.new
      response = service.get_trip_route(origin, destination)

      expect(response).to have_key(:route)
      expect(response[:route]).to be_a(Hash)

      route = response[:route]

      expect(route).to have_key(:time)
      expect(route[:time]).to be_an(Integer)
      expect(route).to have_key(:formattedTime)
      expect(route[:formattedTime]).to be_a(String)
    end

    it 'has an error message when route cannot be found' do
      origin = "Denver, CO" 
      destination = "Taipei, Taiwan" 
      service = MapquestService.new
      response = service.get_trip_route(origin, destination)

      expect(response).to have_key(:route)
      expect(response[:route]).to be_a(Hash)

      route = response[:route]

      expect(route).to have_key(:routeError)
      expect(route[:routeError]).to be_a(Hash)

      expect(route[:routeError]).to have_key(:errorCode)
      expect(route[:routeError][:errorCode]).to be_an(Integer)
      expect(route[:routeError]).to have_key(:message)
      expect(route[:routeError][:message]).to be_a(String)
    end
  end
end