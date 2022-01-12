#frozen_string_literal = true

require 'representable/json'

class WeatherRepresenter < Representable::Decorator
  include Representable::JSON

  property :temperature
  property :datetime
end

