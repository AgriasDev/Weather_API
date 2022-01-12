# frozen_string_literal: true

require 'rufus-scheduler'

scheduler = Rufus::Scheduler.singleton

# to get weather data at application startup
scheduler.in '3s' do
  WeatherDataLoader.call
end

# to update weather data
scheduler.every '1h' do
  WeatherDataLoader.call
end
