# frozen_string_literal: true

require 'tzinfo'

module GlobalTime
  class Timezone
    def time_now(identifier)
      TZInfo::Timezone.get(identifier)
    rescue TZInfo::InvalidTimezoneIdentifier
      nil
    end
  end
end
