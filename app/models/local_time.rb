# frozen_string_literal: true

module Kronika
  class LocalTime
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

    def initialize(time, timezone)
      @time = time
      @timezone = timezone
    end

    def tg_time
      %(<tg-time unix="#{unix_timestamp}" format="t">--</tg-time> Local time)
    end

    def iana_time
      "#{@time.strftime('%H:%M')} #{@timezone.id}"
    end

    private

    def unix_timestamp
      @time.to_i
    end
  end
end
