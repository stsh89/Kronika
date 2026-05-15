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

    def execute(params)
      case params
      in { action: :send_location_sharing_notice }
        message =
          'Please provide a time zone identifier (e.g., /set Europe/London). ' \
          'Alternatively, you can use the /set command in our ' \
          '<a href="https://t.me/KronikaFembot">private chat</a>, ' \
          "and I'll try to automatically detect your time zone based on your location."

        @notification_service.send_html_message(message)
      in { action: :send_location_sharing_request }
        message = 'Please share your location. I will try to determine your time zone.'
        @notification_service.send_location_sharing_request(@chat, message)
      else
        timezone = build_timezone(params)
        user = User.new(id: @user_id, timezone: timezone)

        @storage_service.save_user(user)
        send_message("Your time zone has been set to #{timezone}.")
      end
    end

    private

    def build_timezone(params)
      case params
      in { tz_identifier: tz_identifier }
        begin
          Timezone.new(tz_identifier)
        rescue InvalidArgumentError
          send_message("Invalid time zone identifier: #{tz_identifier}. Please provide a valid time zone.")

          raise
        end
      in { location: location }
        begin
          location = Location.new(**location)
          @geolocation_service.get_timezone(location)
        rescue InvalidArgumentError
          send_message('Could not find your time zone based on your location.')

          raise
        end
      else
        raise InvalidArgumentError, "params: #{params}"
      end
    end

    def send_message(message)
      @notification_service.send_message(@chat, message)
    end
  end
end
