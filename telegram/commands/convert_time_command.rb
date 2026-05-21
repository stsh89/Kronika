# frozen_string_literal: true

module Telegram
  class ConvertTimeCommand < Command
    def initialize(attributes:, time_str:)
      @time_str = time_str

      super(attributes)
    end

    def execute
      time = try_parse_time

      return unless time

      timestamp = container.convert_time.execute(user_id:, hour: time.hour, minutes: time.min)

      return unless timestamp

      send_time_message(timestamp)
    end

    private

    attr_reader :time_str

    def try_parse_time
      Time.strptime(time_str, '%H:%M')
    rescue ArgumentError
      nil
    end

    def send_time_message(timestamp)
      html = [
        %(<tg-time unix="#{timestamp.unix_timestamp}" format="t">--</tg-time> Local time),
        timestamp.iana_label
      ].join("\n")

      send_html(html)
    end
  end
end
