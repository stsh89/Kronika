# frozen_string_literal: true

module Kronika
  class GeolocationService
    def initialize(client)
      @client = client
    end

    def get_timezone(location)
      tz_identifier = @client.get_timezone_id(**location.to_h)
      Timezone.new(tz_identifier)
    end
  end
end
