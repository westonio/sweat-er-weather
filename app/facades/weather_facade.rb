class WeatherFacade
  attr_reader :location, :latitude, :longitude

  def initialize(location)
    @location = location
    @latitude = nil
    @longitude = nil
  end

  def forecast
    find_lat_lon
    weather_data = WeatherService.new(@latitude, @longitude).get_forecast
    Forecast.new(weather_data)
  end

private
  def find_lat_lon
    service = MapquestService.new.get_lat_lon(@location)
    lat_lon = service[:results].first[:locations].first[:displayLatLng]
    @latitude = lat_lon[:lat]
    @longitude = lat_lon[:lng]
  end
end