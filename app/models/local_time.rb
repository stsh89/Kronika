# frozen_string_literal: true

module Kronika
  LocalTime = Data.define(:time, :timezone)

  class LocalTime
    def initialize(time:, timezone:)
      raise 'LocalTime#time cannot be blank' if time.nil?
      raise 'LocalTime#timezone cannot be blank' if timezone.nil?

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
