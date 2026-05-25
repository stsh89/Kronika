# frozen_string_literal: true

module Kronika
  class Chrono
    def initialize(geolocation:, clock:)
      self.geolocation = geolocation
      self.clock = clock
    end

    def get_timezone_by_location(location)
      id = geolocation.get_timezone_id(**location.to_h)

      return if id.nil?

      Timezone.new(id:)
    end

    def get_timezone_by_id(id)
      now = clock.time_now(id)

      return unless now

      Timezone.new(id:)
    end

    def get_timestamp(hour, min, timezone)
      now = clock.time_now(timezone.id)
      time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)

      Timestamp.new(time:, timezone:)
    end

    private

    attr_accessor :geolocation, :clock
  end
end
