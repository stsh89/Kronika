# frozen_string_literal: true

require 'time'

module TelegramWebhook
  class ConvertTimeCommand < Command
    def initialize(attributes:, time_str:)
      self.time_str = time_str

      super(attributes)
    end

    def execute
      time = try_parse_time
      return unless time

      timestamp = kronika_api.convert_time(user_id:, hour: time.hour, minutes: time.min)
      return unless timestamp

      send_time_message(timestamp)
    end

    private

    attr_accessor :time_str

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
