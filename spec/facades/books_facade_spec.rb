require 'rails_helper'

RSpec.describe BooksFacade, type: :facade do
  describe 'Instance Methods', :vcr do
    let(:facade) { BooksFacade.new }

    it 'exists' do
      expect(facade).to be_a(BooksFacade)
    end

    it 'can create a book object by searching titles by location and limiting quantity' do
      location = "San Fransisco"
      quantity = 5
      book = facade.search_books(location, quantity)

      expect(book).to be_a(Book)
    end
  end
end