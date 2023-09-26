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

  def find_weather_at_eta(date_time)
    hour_data = eta_hour_weather(date_time)
    format_eta_weather(hour_data)
  end
  
  def eta_hour_weather(date_time)
    day_data = eta_day_weather(date_time)
    day_data[:hour].select do |hour|
      hour[:time] == date_time.strftime("%Y-%m-%d %H:%M")
    end.first
  end

  def eta_day_weather(date_time)
    @data[:forecast][:forecastday].select do |day|
      day[:date] == date_time.strftime("%Y-%m-%d")
    end.first
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

  def format_eta_weather(data)
    {
      datetime: data[:time],
      temperature: data[:temp_f],
      condition: data[:condition][:text]
    }
  end
  
  def format_time(datetime)
   DateTime.parse(datetime).strftime("%H:%M")
  end
end