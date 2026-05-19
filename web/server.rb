# frozen_string_literal: true

module Web
  class Server
    class << self
      def initialize!
        cfg = Config.load_from_env!

        controller = WebhookController.new(
          secret_token: cfg.telegram_webhook_secret_token,
          clients: {
            geo_names: GeoNames::TimezoneApi.new(cfg.geo_names_username),
            global_time: GlobalTime::Timezone.new,
            telegram: Telegram::BotApi.new(cfg.telegram_bot_token),
            upstash: Upstash::RedisApi.new(cfg.upstash_url, cfg.upstash_token)
          }
        )

        new(controller)
      end
    end

    def initialize(webhook_controller)
      @webhook_controller = webhook_controller
    end

    def handle(request)
      request => { path:, request_method:, body:, headers: }

      case path
      when '/webhook'
        case request_method
        when 'POST'
          Async do
            payload = JSON.parse(body, symbolize_names: true)
            @webhook_controller.execute(payload, headers)
          rescue StandardError => e
            Console.error(e.message, e)
          end
        end
      end
    end
  end
end
