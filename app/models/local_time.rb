# frozen_string_literal: true

module Kronika
  LocalTime = Data.define(:time, :timezone)

  class LocalTime
    def tg_time
      %(<tg-time unix="#{@time.to_i}" format="t">--</tg-time> Local time)
    end

    def iana_time
      "#{@time.strftime('%H:%M')} #{@timezone.id}"
    end
  end
end
