require 'rails_helper'

RSpec.describe 'Book-Search Requests', type: :request do
  describe 'GET /api/v1/book-search?location=ciy,state&quantity=number', :vcr do
    it 'returns the location, forecast, and books matchig the quantity searched' do
      location = "taipei"
      quantity = 5

      get "/api/v1/book-search?location=#{location}&quantity=#{quantity}" 

      require 'pry'; binding.pry

      expect(response).to be_successful
    end
  end
end