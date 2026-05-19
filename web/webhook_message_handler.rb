# frozen_string_literal: true

module Web
  class WebhookMessageHandler
    def initialize(clients:, message:)
      @clients = clients
      @params = WebhookParams.new(message)
    end

    def handle
      case message_type
      in { cmd: { location: } }
        save_timezone({ location: })
      in { cmd: { tz_identifier: } }
        save_timezone({ tz_identifier: })
      in { cmd: :help_set }
        save_timezone({ tz_identifier: nil })
      in { cmd: :get }
        read_timezone
      in { cmd: :unset }
        remove_timezone
      in { cmd: { time_str: } }
        normalize_time(time_str)
      end
    end

    private

    def upstash_client
      @clients.fetch(:upstash)
    end

    def telegram_client
      @clients.fetch(:telegram)
    end

    def global_time_client
      @clients.fetch(:global_time)
    end

    def geo_names_client
      @clients.fetch(:geo_names)
    end

    def message_type
      @params.message_type
    end

    def normalize_time(time_str)
      time = Helpers.try_parse_time(time_str)
      return if time.nil?

      @params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(upstash_client),
        notification: Kronika::NotificationService.new(telegram_client),
        global_time: Kronika::GlobalTimeService.new(global_time_client)
      }

      Kronika::NormalizeTimeOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:, hour: time.hour, minutes: time.min)
    end

    def read_timezone
      @params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(upstash_client),
        notification: Kronika::NotificationService.new(telegram_client)
      }

      Kronika::GetTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:)
    end

    def save_timezone(input)
      @params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(upstash_client),
        notification: Kronika::NotificationService.new(telegram_client),
        geolocation: Kronika::GeolocationService.new(geo_names_client),
        global_time: Kronika::GlobalTimeService.new(global_time_client)
      }

      Kronika::SetTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:, input:)
    end

    def remove_timezone
      @params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(upstash_client),
        notification: Kronika::NotificationService.new(telegram_client)
      }

      Kronika::RemoveTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:)
    end
  end
end
