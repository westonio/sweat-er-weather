class RoadTrip
  attr_reader :id,
              :start_city,
              :end_city,
              :travel_time,
              :weather_at_eta
  
  def initialize(origin, destination, trip_data, forecast_data)
    @id = nil
    @start_city = origin
    @end_city = destination
    @trip = trip_data
    @forecast = forecast_data
    @travel_time = trip_data[:formattedTime] || "Impossible"
    @weather_at_eta = find_weather_at_eta
  end

  private
  def find_weather_at_eta
    if @travel_time == "Impossible"
      {}
    else
      @forecast.find_weather_at_eta(calculate_eta)
    end
  end

  def calculate_eta
    eta = Time.now + @trip[:time]
    eta + 1.hour if eta.min >= 30 
    eta.beginning_of_hour
  end
end