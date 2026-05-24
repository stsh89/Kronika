# frozen_string_literal: true

module Kronika
  Timestamp = Data.define(:time, :timezone) do
    def unix_timestamp
      time.to_i
    end

    def iana_label
      "#{time.strftime('%H:%M')} #{timezone.id}"
    end
  end
end
