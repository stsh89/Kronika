# frozen_string_literal: true

module Kronika
  class SetTimezoneOperation
    def initialize(chat_id, user_id, services)
      @chat = Chat.new(id: chat_id)
      @user_id = user_id
      @storage_service = services[:storage]
      @notification_service = services[:notification]
      @geolocation_service = services[:geolocation]
    end

    def execute(input)
      case input
      in { origin:, tz_identifier: }
        handle_timezone_identifier(origin, tz_identifier)
      in { location: }
        handle_location(**location)
      end
    end

    private

    def handle_location(latitude:, longitude:)
      location = Location.new(latitude:, longitude:)
      timezone = @geolocation_service.get_timezone(location)
      user = User.new(id: @user_id, timezone: timezone)

      @storage_service.save_user(user)
      send_message("Your time zone has been set to #{timezone}.")
    rescue InvalidArgumentError
      send_message('Could not find time zone based on your location.')
    end

    def handle_timezone_identifier(origin, tz_identifier)
      case { origin:, tz_identifier: }
      in { origin: 'private', tz_identifier: nil }
        message = 'Please share your location. I will try to determine your time zone.'

        @notification_service.send_location_sharing_request(@chat, message)
      in { tz_identifier: nil }
        message =
          'Please provide a time zone identifier (e.g., /set Europe/London). ' \
          'Alternatively, you can use the /set command in our ' \
          '<a href="https://t.me/KronikaFembot">private chat</a>, ' \
          "and I'll try to automatically detect your time zone based on your location."

        @notification_service.send_html_message(@chat, message)
      in { tz_identifier: }
        save_timezone(tz_identifier)
      end
    end

    def save_timezone(tz_identifier)
      timezone = Timezone.new(tz_identifier)
      user = User.new(id: @user_id, timezone: timezone)

      @storage_service.save_user(user)
      send_message("Your time zone has been set to #{timezone}.")
    rescue InvalidArgumentError
      send_message("Invalid time zone identifier: #{tz_identifier}. Please provide a valid time zone.")
    end

    def send_message(message)
      @notification_service.send_message(@chat, message)
    end
  end
end
