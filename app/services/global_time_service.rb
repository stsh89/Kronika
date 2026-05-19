# frozen_string_literal: true

module Kronika
  class GlobalTimeService
    def initialize(timezone_client)
      @timezone_client = timezone_client
    end

    def get_timezone(identifier)
      now = @timezone_client.time_now(identifier)

      raise InvalidArgumentError, "Invalid time zone identifier: #{identifier}" unless now

      Timezone.new(identifier:)
    end

    def set_clock(hour, min, timezone)
      now = @timezone_client.time_now(timezone.id)
      time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)

      Clock.new(time:, timezone:)
    end
  end
end
