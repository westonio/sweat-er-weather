class WeatherService
  def initialize(latitude, longitude)
    @lat = latitude
    @lon = longitude
  end

  def get_current
    get_url("/v1/current.json?q=#{@lat},#{@lon}")
  end

  def get_5_days
    get_url("/v1/forecast.json?q=#{@lat},#{@lon}&days=5")
  end

  def get_24_hours
    get_url("/v1/forecast.json?q=#{@lat},#{@lon}&days=1")
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