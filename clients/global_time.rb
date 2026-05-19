# frozen_string_literal: true

require 'tzinfo'

module GlobalTime
  class Timezone
    def initialize
      @client = TZInfo::Timezone
    end

    def time_now(identifier)
      tz = timezone(identifier)

      return unless tz

      tz.now
    end

    private

    def timezone(identifier)
      @client.get(identifier)
    rescue TZInfo::InvalidTimezoneIdentifier
      nil
    end
  end
end
