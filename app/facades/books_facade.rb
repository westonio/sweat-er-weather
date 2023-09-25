class BooksFacade
  def search_books(location, quantity)
    book_data = BooksService.new.get_books(location, quantity)
    weather = WeatherFacade.new(location).forecast
    Book.new(location, weather, book_data)
  end
end