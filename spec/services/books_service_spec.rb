require 'rails_helper'

RSpec.describe BooksService, :vcr do
  context 'searching with a valid location and quantity' do
    it 'returns the necessary book data' do
      location = 'taipei'
      quantity = 2
      service = BooksService.new

      response = service.get_books(location, quantity)

      expect(response).to have_key(:numFound)
      expect(response[:numFound]).to be_an(Integer)

      expect(response).to have_key(:docs)
      expect(response[:docs]).to be_an(Array)
      expect(response[:docs].count).to eq(quantity)

      response[:docs].each do |book|
        expect(book).to have_key(:isbn)
        expect(book[:isbn]).to be_an(Array)
        expect(book[:isbn].first).to be_a(String)
        
        expect(book).to have_key(:title)
        expect(book[:title]).to be_a(String)
        expect(book[:title].downcase).to include(location)
      end
    end
  end
end