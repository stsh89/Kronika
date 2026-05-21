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
        secret_token = config.telegram_webhook_secret_token
        payload = request.payload
        headers = request.headers

        WebhookController
          .new(telegram_bot_api:, container:, secret_token:)
          .execute(payload:, headers:)
      rescue StandardError => e
        Console.error(e.message, e)
      end
    end

    def container
      Kronika::Container.new(
        persistance: upstash,
        geolocation: geo_names,
        clock: global_time
      )
    end

    def geo_names
      GeoNames::TimezoneApi.new(config.geo_names_username)
    end

    def global_time
      GlobalTime::Timezone.new
    end

    def telegram_bot_api
      Telegram::BotApi.new(config.telegram_bot_token)
    end

    def upstash
      Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
    end
  end
end
