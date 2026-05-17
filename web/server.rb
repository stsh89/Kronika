# frozen_string_literal: true

module Web
  class Server
    class << self
      def initialize!
        Config.load_from_env! => {
          telegram_bot_token:,
          upstash_url:,
          upstash_token:,
          geo_names_username:,
          telegram_webhook_secret_token:
        }

        telegram_client = Telegram::BotApi.new(telegram_bot_token)
        upstash_client = Upstash::RedisApi.new(upstash_url, upstash_token)
        geo_names_client = GeoNames::TimezoneApi.new(geo_names_username)

        controller = WebhookController.new(
          telegram_client:,
          upstash_client:,
          geo_names_client:,
          secret_token: telegram_webhook_secret_token
        )

        new(controller)
      end
    end

    def initialize(webhook_controller)
      @webhook_controller = webhook_controller
    end

    def handle(request)
      request => { path:, request_method:, payload:, headers: }

      case path
      when '/webhook'
        case request_method
        when 'POST'
          Async do
            @webhook_controller.execute(payload, headers)
          rescue StandardError => e
            puts e.message
            puts e.full_message
          end
        end
      end
    end
  end
end
