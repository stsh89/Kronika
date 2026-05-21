# frozen_string_literal: true

module Web
  class Server
    def initialize(config)
      @config = config
    end

    def handle(request)
      handle_webhook_request(request) if request.webhook?
    end

    private

    attr_reader :config

    def handle_webhook_request(request)
      Async do
        webhook_controller.execute(request)
      rescue StandardError => e
        Console.error(e.message, e)
      end
    end

    def webhook_controller
      @webhook_controller ||= WebhookController.new(
        secret_token: config.telegram_webhook_secret_token,
        telegram_bot_api:,
        container:
      )
    end

    def container
      Kronika::Container.new(persistence:, geolocation:, clock:)
    end

    def geolocation
      GeoNames::TimezoneApi.new(config.geo_names_username)
    end

    def clock
      SysTime::Clock.new
    end

    def telegram_bot_api
      Telegram::BotApi.new(config.telegram_bot_token)
    end

    def persistence
      Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
    end
  end
end
