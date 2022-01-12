#frozen_string_literal = true
require 'rails_helper'

RSpec.describe Weather do
  include Rack::Test::Methods

  def app
    Weather
  end

  before do
    create(:weather_datum, datetime: 1631628094)
    create(:weather_datum, datetime: 1641628094)
    create(:weather_datum, datetime: 1641528094)
    create_list(:weather_datum, 24)
    create(:weather_datum, temperature: 2.5, datetime: 1641892266)
    create(:weather_datum, temperature: 8.5, datetime: 1641893366)
  end

  context 'GET /weather/current'
  it 'returns current temperature and timestamp' do
    get '/weather/current'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq({"datetime"=>1641893366, "temperature"=>8.5})
  end

  context 'GET /weather/historical'
  it 'returns temperature and timestamp for the last 24 hours' do
    get '/weather/historical'
    expect(last_response.status).to eq(200)
  end

  context 'GET /weather/historical/avg'
  it 'returns average temperature for the last 24 hours' do
    get '/weather/historical/avg'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq({"avg"=>"7.9"})
  end

  context 'GET /weather/historical/max'
  it 'returns maximal temperature for the last 24 hours' do
    get '/weather/historical/max'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq({"datetime"=>1641893366, "temperature"=>8.5})
  end

  context 'GET /weather/historical/min'
  it 'returns minimal temperature for the last 24 hours' do
    get '/weather/historical/min'
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq({"datetime"=>1641892266, "temperature"=>2.5})
  end

  context 'GET /weather/historical/by_time'
  it 'returns temperature for time closest to input' do
    get "/weather/historical/by_time.json?input=#{WeatherDatum.last.datetime + 10000}"
    expect(last_response.status).to eq(200)
    expect(JSON.parse(last_response.body)).to eq({"datetime"=>1641893366, "temperature"=>8.5})
  end
  it 'returns 404 when input is empty' do
    get "/weather/historical/by_time.json?input="
    expect(last_response.status).to eq(404)
  end

  context 'GET /weather/health'
  it 'returns status code 200' do
    get '/weather/health'
    expect(last_response.status).to eq(200)
  end
end
