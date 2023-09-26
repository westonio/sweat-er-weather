class RoadTripFacade
  def initialize(origin, destination)
    @origin = origin
    @destination = destination
  end

  def plan_road_trip
    trip = route_data
    forecast = WeatherFacade.new(@destination).forecast
    RoadTrip.new(@origin, @destination, trip, forecast)
  end

  
  private
  def route_data
    service = MapquestService.new
    data = service.get_trip_route(@origin, @destination)
    data[:route]
  end
end