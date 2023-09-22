class WeatherService

  def get_current_weather(lat, lon)
    get_url("/v1/current.json?q=#{lat},#{lon}")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "http://api.weatherapi.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.weather[:key]
    end
  end
end