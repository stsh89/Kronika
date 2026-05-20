# frozen_string_literal: true

module Kronika
  class GlobalTimeService
    def initialize(timezone_client)
      @timezone_client = timezone_client
    end

    def get_timezone(id)
      now = timezone_client.time_now(id)

      return unless now

      Timezone.new(id:)
    end

    def set_clock(hour, min, timezone)
      now = timezone_client.time_now(timezone.id)
      time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)

      Clock.new(time:, timezone:)
    end

    private

    attr_reader :timezone_client
  end
end
