require 'rails_helper'

RSpec.describe 'Book-Search Requests', type: :request do
  describe 'GET /api/v1/book-search?location=ciy,state&quantity=number', :vcr do
    it 'returns the location, forecast, and books matchig the quantity searched' do
      location = "taipei"
      quantity = 5

      get "/api/v1/book-search?location=#{location}&quantity=#{quantity}" 

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json).to have_key(:data)
      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:id]).to be_nil
      expect(json[:data][:type]).to eq("books")

      expect(json[:data]).to have_key(:attributes)
      expect(json[:data][:attributes]).to be_a(Hash)

      attributes = json[:data][:attributes]

      expect(attributes.keys).to eq([:destination, :forecast, :total_books_found, :books])
      expect(attributes[:destination]).to eq(location)

      expect(attributes[:forecast]).to be_a(Hash)
      expect(attributes[:forecast].keys).to eq([:summary,:temperature])
      expect(attributes[:forecast][:summary]).to be_a(String)
      expect(attributes[:forecast][:temperature]).to be_a(String) # Adds F to the end of the float

      expect(attributes[:total_books_found]).to be_an(Integer)

      expect(attributes[:books]).to be_an(Array)
      expect(attributes[:books].count).to eq(quantity)

      attributes[:books].each do |book|
        expect(book.keys).to eq([:isbn, :title])
        expect(book[:isbn]).to be_an(Array)
        expect(book[:isbn].first).to be_a(String)
        expect(book[:title]).to be_a(String)
      end
    end
  end
end