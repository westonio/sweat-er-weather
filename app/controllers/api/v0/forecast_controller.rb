class Api::V0::ForecastController < ApplicationController
  def index
    begin
      render json: ForecastSerializer.new(WeatherFacade.new(params[:location]).forecast)
    rescue StandardError => e
      require 'pry'; binding.pry
    end
  end
end