require 'rails_helper'

RSpec.describe RoadTripFacade, type: :facade do
  describe 'Instance Methods', :vcr do
    let(:origin) { "Denver, CO" } 
    let(:destination) { "New York, NY" } 
    let(:facade) { RoadTripFacade.new(origin, destination) }

    it 'exists' do
      expect(facade).to be_a(RoadTripFacade)
    end

    it 'can find needed route data' do
      data = facade.send(:route_data)
      
      expect(data[:formattedTime]).to eq("24:55:32")
      expect(data[:time]).to eq(89732)
    end
  end
end