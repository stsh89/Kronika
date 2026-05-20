# frozen_string_literal: true

module Kronika
  class GeolocationService
    def initialize(client)
      @client = client
    end

    def get_timezone(location)
      id = client.get_timezone_id(**location.to_h)

      return if id.nil?

      Timezone.new(id:)
    end

    private

    attr_reader :client
  end
end
