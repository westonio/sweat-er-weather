class MapquestService

  def get_trip_route(origin, destination)
    get_url("/directions/v2/route?from=#{origin}&to=#{destination}")
  end


  def get_lat_lon(location)
    get_url("/geocoding/v1/address?location=#{location}")
  end

  def get_url(url)
    response = conn.get(url)
    JSON.parse(response.body, symbolize_names: true)
  end

  def conn
    Faraday.new(url: "https://www.mapquestapi.com") do |faraday|
      faraday.params["key"] = Rails.application.credentials.mapquest[:key]
    end
  end
end