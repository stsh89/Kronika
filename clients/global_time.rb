# frozen_string_literal: true

require 'tzinfo'

module GlobalTime
  class Timezone
    def time_now(identifier)
      tz = TZInfo::Timezone.get(identifier)

      { now: tz.now.to_time }
    rescue TZInfo::InvalidTimezoneIdentifier
      { error: :invalid_timezone_identifier }
    end
  end
end
