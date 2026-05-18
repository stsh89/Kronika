# frozen_string_literal: true

module Web
  class WebhookController
    def initialize(attributes)
      @geo_names_client = attributes[:geo_names_client]
      @global_time_client = attributes[:global_time_client]
      @secret_token = attributes[:secret_token]
      @telegram_client = attributes[:telegram_client]
      @upstash_client = attributes[:upstash_client]
    end

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
    def execute(payload, headers)
      verify_request_authenticity!(headers)

      chat_id = payload.dig(:message, :chat, :id)
      chat_type = payload.dig(:message, :chat, :type)
      user_id = payload.dig(:message, :from, :id)

      return if chat_id.nil? || chat_type.nil? || user_id.nil?

      case payload
      in { message: { location: } }
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client),
          geolocation: Kronika::GeolocationService.new(@geo_names_client),
          global_time: Kronika::GlobalTimeService.new(@global_time_client)
        }

        Kronika::SetTimezoneOperation
          .new(chat_id, user_id, services)
          .execute({ location: })
      in { message: { text: } }
        case text
        when '/unset', '/unset@KronikaFembot'
          services = {
            storage: Kronika::StorageService.new(@upstash_client),
            notification: Kronika::NotificationService.new(@telegram_client)
          }

          Kronika::RemoveTimezoneOperation
            .new(chat_id, user_id, services)
            .execute
        when '/set', '/set@KronikaFembot'
          services = {
            storage: Kronika::StorageService.new(@upstash_client),
            notification: Kronika::NotificationService.new(@telegram_client),
            geolocation: Kronika::GeolocationService.new(@geo_names_client),
            global_time: Kronika::GlobalTimeService.new(GlobalTime::Timezone)
          }

          Kronika::SetTimezoneOperation
            .new(chat_id, user_id, services)
            .execute({ origin: chat_type, tz_identifier: nil })
        when %r{^/set(?:@KronikaFembot)? (.+)}
          services = {
            storage: Kronika::StorageService.new(@upstash_client),
            notification: Kronika::NotificationService.new(@telegram_client),
            geolocation: Kronika::GeolocationService.new(@geo_names_client),
            global_time: Kronika::GlobalTimeService.new(GlobalTime::Timezone)
          }

          Kronika::SetTimezoneOperation
            .new(chat_id, user_id, services)
            .execute({ origin: chat_type, tz_identifier: ::Regexp.last_match(1) })
        when '/get', '/get@KronikaFembot'
          services = {
            storage: Kronika::StorageService.new(@upstash_client),
            notification: Kronika::NotificationService.new(@telegram_client)
          }

          Kronika::GetTimezoneOperation
            .new(chat_id, user_id, services)
            .execute
        when /(\d{1,2}:\d{2})/
          services = {
            storage: Kronika::StorageService.new(@upstash_client),
            notification: Kronika::NotificationService.new(@telegram_client),
            global_time: Kronika::GlobalTimeService.new(GlobalTime::Timezone)
          }

          begin
            time = Time.strptime(::Regexp.last_match(1), '%H:%M')
          rescue ArgumentError
            return
          end

          Kronika::NormalizeTimeOperation
            .new(chat_id, user_id, services)
            .execute(time.hour, time.min)
        end
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength

    private

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']
      want = @secret_token

      raise 'Missing Telegram webhook secret token' if got == '' || got.nil?
      raise 'Invalid Telegram webhook secret token' if got != want
    end
  end
end
