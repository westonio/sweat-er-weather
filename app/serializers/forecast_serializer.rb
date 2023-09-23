class ForecastSerializer
  include JSONAPI::Serializer

  attributes :current, :daily, :hourly
end