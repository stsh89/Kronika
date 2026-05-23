# frozen_string_literal: true

module Web
  class WebhookController
    def initialize(config)
      @config = config
    end

    def call(env)
      handler = telegram_webhook_handler(env)

      Async do
        handler.handle
      rescue StandardError => e
        Console.error(e.message, e)
      end

      [200, {}, []]
    end

    private

    attr_reader :config

    def telegram_webhook_handler(env)
      req = ::Rack::Request.new(env)
      body = req.body&.read.to_s
      payload = JSON.parse(body, symbolize_names: true)
      headers = req.env.select { |k, _v| k.start_with?('HTTP_') }

      Telegram::WebhookHandler.new(
        payload:,
        headers:,
        secret_token:,
        bot_api:,
        kronika_api:
      )
    end

    def secret_token
      config.telegram_webhook_secret_token
    end

    def kronika_api
      @kronika_api ||= Web::KronikaApi.new(persistence:, geolocation:, clock:)
    end

    def geolocation
      GeoNames::TimezoneApi.new(config.geo_names_username)
    end

    def clock
      SysTime::Clock.new
    end

    def bot_api
      @bot_api ||= Telegram::BotApi.new(config.telegram_bot_token)
    end

    def persistence
      Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
    end
  end
end
