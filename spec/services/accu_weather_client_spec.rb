# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccuWeatherClient do

  subject(:instance) do
    described_class.new(Rails.application.credentials.apikey)
  end

  describe '#weather' do
    let(:weather) { instance.weather }
    context 'when gets response with weather data' do
      it 'has all correct weather attributes', :vcr do
        expect(weather[0].keys).to include('EpochTime', 'Temperature')
      end
    end
  end
end

