# frozen_string_literal: true

module Web
  class WebhookController
    include Helpers

    def initialize(attributes)
      @geo_names_client = attributes[:geo_names_client]
      @global_time_client = attributes[:global_time_client]
      @secret_token = attributes[:secret_token]
      @telegram_client = attributes[:telegram_client]
      @upstash_client = attributes[:upstash_client]
    end

    def execute(payload, headers)
      verify_request_authenticity!(headers)
      params = WebhookParams.from_payload!(payload)

      case params.message
      in { location: }
        set_timezone(params, { location: })
      in { text: }
        handle_text(params, text)
      end
    end

    private

    def handle_text(params, text)
      case text
      when '/unset', '/unset@KronikaFembot'
        unset_timezone(params)
      when '/set', '/set@KronikaFembot'
        set_timezone(params, { tz_identifier: nil })
      when %r{^/set(?:@KronikaFembot)? (.+)}
        tz_identifier = ::Regexp.last_match(1)
        set_timezone(params, { tz_identifier: })
      when '/get', '/get@KronikaFembot'
        get_timezone(params)
      when /(\d{1,2}:\d{2})/
        time_str = ::Regexp.last_match(1)
        time = Helpers.try_parse_time(time_str)

        return if time.nil?

        normalize_time(params, time)
      end
    end

    def normalize_time(params, time)
      params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client),
        global_time: Kronika::GlobalTimeService.new(@global_time_client)
      }

      Kronika::NormalizeTimeOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:, hour: time.hour, minutes: time.min)
    end

    def get_timezone(params)
      params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::GetTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:)
    end

    def set_timezone(params, input)
      params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client),
        geolocation: Kronika::GeolocationService.new(@geo_names_client),
        global_time: Kronika::GlobalTimeService.new(@global_time_client)
      }

      Kronika::SetTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:, input:)
    end

    def unset_timezone(params)
      params => { chat_id:, chat_type:, user_id: }

      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::RemoveTimezoneOperation
        .new(services)
        .execute(chat_id:, chat_type:, user_id:)
    end

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']
      want = @secret_token

      raise 'Missing Telegram webhook secret token' if got == '' || got.nil?
      raise 'Invalid Telegram webhook secret token' if got != want
    end
  end
end
