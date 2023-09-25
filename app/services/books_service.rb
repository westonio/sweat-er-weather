class BooksService

  def get_books(location, quantity)
    get_url("/search.json?title=#{location}&limit=#{quantity}")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end
  
  def conn
    Faraday.new(url: "https://openlibrary.org") do |faraday|
      faraday.params["key"] = Rails.application.credentials.weather[:key]
    end
  end
end