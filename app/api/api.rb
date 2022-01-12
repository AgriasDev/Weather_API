# frozen_string_literal: true

class API < Grape::API
  prefix 'weather'
  format :json
  mount Weather
end

