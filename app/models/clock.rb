# frozen_string_literal: true

module Kronika
  Clock = Data.define(:time, :timezone)

  class Clock
    def initialize(time:, timezone:)
      raise InvalidArgumentError, "Clock time can't be blank." if time.nil?
      raise InvalidArgumentError, "Clock time zone can't be blank." if timezone.nil?

      super
    end

    def tg_time
      %(<tg-time unix="#{time.to_i}" format="t">--</tg-time> Local time)
    end

    def iana_time
      "#{time.strftime('%H:%M')} #{timezone.id}"
    end
  end
end
