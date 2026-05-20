# frozen_string_literal: true

module Telegram
  class SaveTimezoneCommand < Command
    def initialize(chat_id:, chat_type:, user_id:, clients:, input:)
      @input = input

      super(chat_id:, chat_type:, user_id:, clients:)
    end

    def execute
      user = save_timezone

      if user
        send_text("Your time zone has been set to #{user.timezone.id}.")
        return
      end

      case input
      in { timezone_id: }
        send_text("Invalid time zone identifier: #{timezone_id}. Please provide a valid time zone.")
      in { location: }
        send_text('Could not find time zone based on your location.')
      end
    end

    private

    attr_reader :input

    def save_timezone
      services = {
        storage: Kronika::StorageService.new(upstash),
        geolocation: Kronika::GeolocationService.new(geo_names),
        global_time: Kronika::GlobalTimeService.new(global_time)
      }

      Kronika::SaveTimezoneOperation
        .new(**services)
        .execute(user_id:, input:)
    end
  end
end
