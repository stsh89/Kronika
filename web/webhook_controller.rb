# frozen_string_literal: true

module Web
  class WebhookController
    def initialize(config)
      @config = config
    end

    def execute(request)
      verify_request_authenticity!(request.headers)

      Telegram::Command.from_payload(
        payload: request.payload,
        bot_api: telegram_bot_api,
        container:
      )&.execute
    end

    private

    attr_reader :config

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']

      raise 'Missing Telegram webhook secret token' if got.to_s.empty?
      raise 'Invalid Telegram webhook secret token' if got != secret_token
    end

    def secret_token
      config.telegram_webhook_secret_token
    end

    def container
      @container ||= Web::KronikaContainer.new(persistence:, geolocation:, clock:)
    end

    def geolocation
      GeoNames::TimezoneApi.new(config.geo_names_username)
    end

    def clock
      SysTime::Clock.new
    end

    def telegram_bot_api
      @telegram_bot_api ||= Telegram::BotApi.new(config.telegram_bot_token)
    end

    def persistence
      Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
    end
  end
end
