# frozen_string_literal: true

require 'geo_names'
require 'kronika'

class GeoNamesChrono
  def initialize
    username = APP_ENV['GEO_NAMES_USERNAME']
    self.client = GeoNames::Timezone::Api.new(username)
  end

  def get_timezone_by_location(location)
    id = client.get_timezone_id(**location.to_h)

    Kronika::Timezone.new(id:) if id
  end

  private

  attr_accessor :client
end
