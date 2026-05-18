# frozen_string_literal: true

module Kronika
  class GlobalTimeService
    def initialize(timezone_client)
      @timezone_client = timezone_client
    end

    def get_timezone(identifier)
      case @timezone_client.time_now(identifier)
      in { now: }
        Timezone.new(identifier:)
      in { error: :invalid_timezone_identifier }
        raise InvalidArgumentError, "Invalid time zone identifier: #{identifier}"
      end
    end

    def get_local_time(hour, min, timezone)
      case @timezone_client.time_now(timezone.id)
      in { now: }
        time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)
        LocalTime.new(time, timezone)
      end
    end
  end
end
