class Api::V0::RoadTripController < ApplicationController
  def create
    begin
      validate_api_key
      road_trip = RoadTripFacade.new(params[:origin], params[:destination]).plan_road_trip
      render json: RoadTripSerializer.new(road_trip)
    rescue StandardError => e
      require 'pry'; binding.pry
    end
  end

private
  def validate_api_key
    user = User.find_by(api_key: params[:api_key])
    raise "Invalid Api Key" unless user
    user
  end
end