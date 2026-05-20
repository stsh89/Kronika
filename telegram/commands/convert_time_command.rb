# frozen_string_literal: true

module Telegram
  class ConvertTimeCommand < Command
    def initialize(chat_id:, chat_type:, user_id:, clients:, time_str:)
      @time_str = time_str

      super(chat_id:, chat_type:, user_id:, clients:)
    end

    def execute
      time = try_parse_time

      return unless time

      clock = convert_time(time)

      return unless clock

      send_time_message(clock)
    end

    private

    attr_reader :time_str

    def try_parse_time
      Time.strptime(time_str, '%H:%M')
    rescue ArgumentError
      nil
    end

    def convert_time(time)
      services = {
        storage: Kronika::StorageService.new(upstash),
        global_time: Kronika::GlobalTimeService.new(global_time)
      }

      Kronika::ConvertTimeOperation
        .new(**services)
        .execute(user_id:, hour: time.hour, minutes: time.min)
    end

    def send_time_message(clock)
      html = [
        %(<tg-time unix="#{clock.unix_timestamp}" format="t">--</tg-time> Local time),
        clock.iana_label
      ].join("\n")

      send_html(html)
    end
  end
end
