# frozen_string_literal: true

module Telegram
  class ConvertTimeCommand < Command
    def initialize(attributes:, time_str:)
      @time_str = time_str

      super(attributes)
    end

    def execute
      params = operation_params
      return unless params

      timestamp = container.convert_time.execute(**params)
      return unless timestamp

      send_time_message(timestamp)
    end

    private

    attr_reader :time_str

    def operation_params
      time = try_parse_time
      return unless time

      { tenant_name:, identity_badges:, hour: time.hour, minutes: time.min }
    end

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
