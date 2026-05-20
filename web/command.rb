# frozen_string_literal: true

module Web
  class Command
    class << self
      def from_payload(payload:, clients:)
        CommandBuilder.new(payload:, clients:).build
      end
    end

    def initialize(chat_id:, chat_type:, user_id:, clients:)
      @chat_id = chat_id
      @chat_type = chat_type
      @user_id = user_id
      @clients = clients
    end

    private

    attr_reader :chat_id, :chat_type, :user_id, :clients

    def send_text(text)
      telegram.send_message(chat_id, text)
    end

    def send_html(html)
      telegram.send_message(chat_id, html, { parse_mode: 'HTML' })
    end

    def global_time
      clients.fetch(:global_time)
    end

    def telegram
      clients.fetch(:telegram)
    end

    def geo_names
      clients.fetch(:geo_names)
    end

    def upstash
      clients.fetch(:upstash)
    end
  end

  class NilCommand
    def execute; end
  end

  class SendLocationSharingRequestCommand < Command
    def execute
      telegram.send_message(
        chat_id,
        'Please share your location. I will try to determine your time zone.',
        reply_markup: {
          keyboard: [[
            {
              text: '📍 Share My Location',
              request_location: true
            }
          ]],
          resize_keyboard: true,
          one_time_keyboard: true
        }
      )
    end
  end

  class SendHelpMessageCommand < Command
    def execute
      send_html(
        'Please provide a time zone identifier (e.g., /set Europe/London). ' \
        'Alternatively, you can use the /set command in our ' \
        '<a href="https://t.me/KronikaFembot">private chat</a>, ' \
        "and I'll try to automatically detect your time zone based on your location."
      )
    end
  end

  class ReadTimezoneCommand < Command
    def execute
      user = read_timezone

      if user
        send_text("Your time zone is set to #{user.timezone.id}.")
      else
        send_text("You haven't set a time zone yet. Use /set to set it.")
      end
    end

    private

    def read_timezone
      services = { storage: Kronika::StorageService.new(upstash) }
      Kronika::ReadTimezoneOperation.new(**services).execute(user_id:)
    end
  end

  class DropTimezoneCommand < Command
    def execute
      drop_timezone
      send_text('Your time zone has been removed.')
    end

    private

    def drop_timezone
      services = { storage: Kronika::StorageService.new(upstash) }
      Kronika::RemoveTimezoneOperation.new(**services).execute(user_id:)
    end
  end

  class ConvertTimeCommand < Command
    def initialize(chat_id:, chat_type:, user_id:, clients:, time_str:)
      @time_str = time_str

      super(chat_id:, chat_type:, user_id:, clients:)
    end

    def execute
      time = Helpers.try_parse_time(time_str)

      return unless time

      clock = convert_time(time)

      return unless clock

      send_time_message(clock)
    end

    private

    attr_reader :time_str

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
