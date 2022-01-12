# frozen_string_literal: true

require 'rest-client'
require 'json'

# Connect to and parse data from AccuWeather Base
class AccuWeatherClient
  URL = 'http://dataservice.accuweather.com/currentconditions/v1/293686/historical/24'

  def initialize(apikey)
    @apikey = apikey
  end

  def weather
    response = RestClient::Request.execute(method: :get, url: URL.to_s, headers:
      { params: { apikey: @apikey.to_s }, content_type: :json, accept: :json })
    parse(response)
  rescue => e
    Rails.logger.error [e.message, e.backtrace].join($/)
  end

  private

  def parse(response)
    response.code == 200 ? JSON.parse(response.body) : nil
    end
end


