# frozen_string_literal: true

module Kronika
  class SetTimezoneOperation
    def initialize(services)
      @storage_service = services[:storage]
      @notification_service = services[:notification]
      @geolocation_service = services[:geolocation]
      @global_time_service = services[:global_time]
    end

    def execute(chat_id:, chat_type:, user_id:, input:)
      chat = Chat.new(id: chat_id, chat_type:)

      case get_timezone(input)
      in { error: :missing }
        send_location_sharing_notification(chat)

      in { error: :invalid_identifier }
        send_message(chat, "Invalid time zone identifier: #{tz_identifier}. Please provide a valid time zone.")

      in { error: :location_lookup }
        send_message(chat, 'Could not find time zone based on your location.')

      in { timezone: }
        save_user(id: user_id, timezone:)
        send_message(chat, "Your time zone has been set to #{timezone.id}.")
      end
    end

    private

    def save_user(id:, timezone:)
      user = User.new(id:, timezone:)
      @storage_service.save_user(user)
      user
    end

    def get_timezone(input)
      case input
      in { tz_identifier: nil }
        { error: :missing }

      in { tz_identifier: }
        timezone = get_timezone_by_identifier(tz_identifier)
        timezone ? { timezone: } : { error: :invalid_identifier }

      in { location: }
        location = Location.new(**location)
        timezone = get_timezone_by_location(location)
        timezone ? { timezone: } : { error: :location_lookup }
      end
    end

    def send_location_sharing_notification(chat)
      if chat.private?
        @notification_service.send_location_sharing_request(
          chat,
          'Please share your location. I will try to determine your time zone.'
        )
      else
        @notification_service.send_html_message(
          chat,
          'Please provide a time zone identifier (e.g., /set Europe/London). ' \
          'Alternatively, you can use the /set command in our ' \
          '<a href="https://t.me/KronikaFembot">private chat</a>, ' \
          "and I'll try to automatically detect your time zone based on your location."
        )
      end
    end

    def get_timezone_by_location(location)
      @geolocation_service.get_timezone(location)
    rescue InvalidArgumentError
      nil
    end

    def get_timezone_by_identifier(identifier)
      @global_time_service.get_timezone(identifier)
    rescue InvalidArgumentError
      nil
    end

    def send_message(chat, message)
      @notification_service.send_message(chat, message)
    end
  end
end
