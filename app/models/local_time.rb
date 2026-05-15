# frozen_string_literal: true

module Kronika
  class LocalTime
    def initialize(time, timezone)
      @time = time
      @timezone = timezone
    end

    def unix_timestamp
      @time.to_i
    end

    class << self
      def from_string(time_str, timezone)
        parsed = Time.strptime(time_str, '%H:%M')
        tz = TZInfo::Timezone.get(timezone.identifier)
        now = tz.now
        time = tz.local_time(now.year, now.month, now.day, parsed.hour, parsed.min).to_time

        new(time, timezone)
      rescue ArgumentError
        raise InvalidArgumentError, "Invalid time: `#{time_str}`."
      end
    end
  end
end
