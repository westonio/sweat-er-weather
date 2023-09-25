class Book
  attr_reader :id,
              :destination,
              :forecast,
              :total_books_found,
              :books

  def initialize(destination, weather, book_data)
    @id = nil
    @destination = destination
    @forecast = format_weather(weather.current)
    @total_books_found = book_data[:numFound]
    @books = book_results(book_data[:docs])
  end

private
  def book_results(book_data)
    book_data.map do |book|
      format_book(book)
    end
  end
  
  def format_book(book)
    {
      isbn: book[:isbn],
      title: book[:title]
    }
  end

  def format_weather(weather)
    {
      summary: weather[:condition],
      temperature: weather[:temperature]
    }
  end
end