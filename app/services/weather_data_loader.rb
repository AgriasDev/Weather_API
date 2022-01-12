# frozen_string_literal: true

class WeatherDataLoader
  class << self
    def call
      client = AccuWeatherClient.new(Rails.application.credentials.apikey)
      client.weather.each do |data|
        WeatherDatum.where(datetime: data['EpochTime'])
                    .first_or_create(temperature: data.dig('Temperature', 'Metric', 'Value'))
      rescue => e
        Rails.logger.error [e.message, e.backtrace].join($/)
      end
    end
  end
end
