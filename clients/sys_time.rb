# frozen_string_literal: true

require 'tzinfo'

module SysTime
  class Clock
    def initialize
      @client = TZInfo::Timezone
    end

    def time_now(timezone_id)
      tz = get_timezone(timezone_id)

      return unless tz

      tz.now
    end

    private

    attr_reader :client

    def get_timezone(timezone_id)
      client.get(timezone_id)
    rescue TZInfo::InvalidTimezoneIdentifier
      nil
    end
  end
end
