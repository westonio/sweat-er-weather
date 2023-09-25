class BooksFacade
  def initialize(location, quantity)
    @location = location
    @quantity = quantity
  end

  def search_books
    service = BooksService.new
    service.get_books(@location, @quantity)
  end
end