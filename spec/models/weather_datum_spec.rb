# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeatherDatum, type: :model do
  let(:weather) { create(:weather_datum) }

  context 'when object is valid' do
    it { expect(weather).to be_valid }
  end
end

