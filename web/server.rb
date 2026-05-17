# frozen_string_literal: true

module Web
  class Server
    class << self
      def initialize!
        cfg = Config.load_from_env!
        controller = WebhookController.new(
          telegram_client: Telegram::BotApi.new(cfg.telegram_bot_token),
          upstash_client: Upstash::RedisApi.new(cfg.upstash_url, cfg.upstash_token),
          geo_names_client: GeoNames::TimezoneApi.new(cfg.geo_names_username),
          secret_token: cfg.telegram_webhook_secret_token
        )

        new(controller)
      end
    end

    def initialize(webhook_controller)
      @webhook_controller = webhook_controller
    end

    def handle(request)
      case request.path
      when '/webhook'
        case request.request_method
        when 'POST'
          Async do
            payload = JSON.parse(request.body, symbolize_names: true)

            @webhook_controller.execute(payload, request.headers)
          rescue StandardError => e
            puts e.message
            puts e.full_message
          end
        end
      end
    end
  end
end
