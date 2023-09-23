class Forecast
  attr_reader :id, :current, :daily, :hourly
  
  def initialize(data)
    @id = nil
    @data = data
    @current = current_weather
    @daily = daily_weather
    @hourly = hourly_weather
  end

  def current_weather
    {
      last_updated: @data[:current][:last_updated],
      temperature: @data[:current][:temp_f],
      feels_like: @data[:current][:feelslike_f],
      humidity: @data[:current][:humidity],
      uvi: @data[:current][:uv],
      visibility: @data[:current][:vis_miles],
      condition: @data[:current][:condition][:text],
      icon: @data[:current][:condition][:icon]
    }
  end

  def daily_weather
    @data[:forecast][:forecastday].map do |day|
      format_daily_weather(day)
    end
  end

  def hourly_weather
    hours = @data[:forecast][:forecastday].first[:hour]
    hours.map do |hour|
      format_hourly_weather(hour)
    end
  end

private
  def format_daily_weather(day)
    {
      date: day[:date],
      sunrise: day[:astro][:sunrise],
      sunset: day[:astro][:sunset],
      max_temp: day[:day][:maxtemp_f],
      min_temp: day[:day][:mintemp_f],
      condition: day[:day][:condition][:text],
      icon: day[:day][:condition][:icon]
    }
  end
  
  def format_hourly_weather(hour)
    {
      time: format_time(hour[:time]),
      temperature: hour[:temp_f],
      condition: hour[:condition][:text],
      icon: hour[:condition][:icon]
    }
  end
  
  def format_time(datetime)
   DateTime.parse(datetime).strftime("%H:%M")
  end
end