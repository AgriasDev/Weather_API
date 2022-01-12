# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherDataLoader do
  subject(:call) { described_class.call }

  let(:fake_client) { instance_double(AccuWeatherClient) }

  before do
    allow(AccuWeatherClient).to receive(:new).and_return(fake_client)
    allow(fake_client).to receive(:weather).and_return([{ 'EpochTime' => 1641640013,
                                                          'Temperature' => { 'Metric' => { 'Value' => 5 } } }])
  end

  context 'when client returns correct weather data' do
    it 'adds new weather data to DB with correct attributes', :aggregate_failures do
      call
      expect(WeatherDatum.count).to eq(1)
      expect(WeatherDatum.last).to have_attributes(temperature: 5, datetime: 1641640013)
    end
  end

  context 'when client returns correct data with the same datetime' do
    before { create(:weather_datum, datetime: 1641640013) }

    it 'does not duplicate records' do
      expect { call }.not_to change(WeatherDatum, :count).from(1)
    end
  end
end

