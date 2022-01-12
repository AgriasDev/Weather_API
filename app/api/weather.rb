# frozen_string_literal: true

class Weather < Grape::API
  helpers do
    def weather_data_for_last_24h
      WeatherDatum.where('datetime >= ? and datetime <= ?', Time.now.to_i - (60 * 60 * 24), Time.now.to_i)
    end
  end

  desc 'Returns current temperature'
  get "/current" do
    WeatherRepresenter.new(WeatherDatum.order('datetime DESC').first)
  end

  namespace :historical do
    desc 'Returns historical temperature for last 24 hours'
    get "/" do
      WeatherRepresenter.for_collection.new(WeatherDatum.order('datetime DESC').take(24))
    end

    desc 'Returns average temperature for last 24 hours'
    get "/avg" do
      {:avg => weather_data_for_last_24h.average(:temperature).floor(1)}
    end

    desc 'Returns maximum temperature for last 24 hours'
    get "/max" do
      WeatherRepresenter.new(weather_data_for_last_24h.order('temperature DESC').first)
    end

    desc 'Returns minimum temperature for last 24 hours'
    get "/min" do
      WeatherRepresenter.new(weather_data_for_last_24h.order('temperature ASC').first)
    end

    params do
      requires :input, type: Integer
    end
    get "/by_time" do
      return error!('Not Found', 404) if params[:input].blank?

      WeatherRepresenter.new(
        (WeatherDatum.find_by_sql ["SELECT * from weather_data order by  ABS(datetime - ?) ASC LIMIT 1",
                                   params[:input].to_i])[0])
    end
  end

  get "/health" do
    status 200
  end
end



