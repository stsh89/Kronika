# frozen_string_literal: true

class WebhookController
  def initialize(attributes)
    @secret_token = attributes[:secret_token]
    @telegram_client = attributes[:telegram_client]
    @upstash_client = attributes[:upstash_client]
    @geo_names_client = attributes[:geo_names_client]
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength
  def execute(payload, headers)
    verify_request_authenticity!(headers)

    chat_id = payload.dig(:message, :chat, :id)
    user_id = payload.dig(:message, :from, :id)

    nil if chat_id.nil? || user_id.nil?

    case payload
    in { message: { location: location } }
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client),
        geolocation: Kronika::GeolocationService.new(@geo_names_client)
      }

      Kronika::SetTimezoneOperation
        .new(chat_id, user_id, services)
        .execute({ location: })
    in { message: { text: text } }
      case text
      when '/unset'
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client)
        }

        Kronika::RemoveTimezoneOperation.new(chat_id, user_id, services).execute
      when '/set@KronikaFembot'
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client),
          geolocation: Kronika::GeolocationService.new(@geo_names_client)
        }

        Kronika::SetTimezoneOperation
          .new(chat_id, user_id, services)
          .execute({ action: :send_location_sharing_notice })
      when '/set'
        chat_type = payload.dig(:message, :chat, :type)

        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client),
          geolocation: Kronika::GeolocationService.new(@geo_names_client)
        }

        action =
          case chat_type
          when 'private'
            :send_location_sharing_request
          else
            :send_location_sharing_notice
          end

        Kronika::SetTimezoneOperation.new(chat_id, user_id, services).execute({ action: })
      when %r{^/set (.+)}
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client),
          geolocation: Kronika::GeolocationService.new(@geo_names_client)
        }

        Kronika::SetTimezoneOperation
          .new(chat_id, user_id, services)
          .execute({ tz_identifier: ::Regexp.last_match(1).strip })
      when '/get'
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client)
        }

        Kronika::GetTimezoneOperation.new(chat_id, user_id, services).execute
      when /(\d{1,2}:\d{2})/
        services = {
          storage: Kronika::StorageService.new(@upstash_client),
          notification: Kronika::NotificationService.new(@telegram_client)
        }

        Kronika::NormalizeTimeOperation
          .new(chat_id, user_id, services)
          .execute(::Regexp.last_match(1))
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
