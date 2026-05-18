# frozen_string_literal: true

module Kronika
  LocalTime = Data.define(:time, :timezone)

  class LocalTime
    def initialize(time:, timezone:)
      raise InvalidArgumentError, "Local time can't be blank." if time.nil?
      raise InvalidArgumentError, "Local time timezone can't be blank." if timezone.nil?

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
