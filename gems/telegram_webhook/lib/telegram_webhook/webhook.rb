# frozen_string_literal: true

require 'geo_names'
require 'json'
require 'kronika'
require 'rack'
require 'telegram'
require 'upstash'

require_relative 'command'
require_relative 'convert_time_command'
require_relative 'drop_timezone_command'
require_relative 'read_timezone_command'
require_relative 'save_timezone_command'
require_relative 'send_help_message_command'
require_relative 'send_location_sharing_request_command'
require_relative 'command_builder'

require_relative 'clock'
require_relative 'kronika_api'

module TelegramWebhook
  class Webhook
    def initialize(config)
      self.config = config
    end

    def command(req)
      headers = req.env.select { |k, _v| k.start_with?('HTTP_') }
      verify_request_authenticity!(headers)

      body = req.body ? req.body.read : '{}'
      payload = JSON.parse(body, symbolize_names: true)

      Command.from_payload(payload:, bot_api:, kronika_api:)
    end

    private

    attr_accessor :config

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']

      raise 'Missing Telegram webhook secret token' if got.to_s.empty?
      raise 'Invalid Telegram webhook secret token' if got != secret_token
    end

    def secret_token
      config.telegram_webhook_secret_token
    end

    def kronika_api
      @kronika_api ||= KronikaApi.new(persistence:, geolocation:, clock:)
    end

    def geolocation
      GeoNames::TimezoneApi.new(config.geo_names_username)
    end

    def clock
      Clock.new
    end

    def bot_api
      @bot_api ||= Telegram::BotApi.new(config.telegram_bot_token)
    end

    def persistence
      Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
    end
  end
end
