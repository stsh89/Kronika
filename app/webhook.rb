# frozen_string_literal: true

require 'geo_names'
require 'json'
require 'kronika'
require 'telegram'
require 'upstash'

require_relative 'clock'
require_relative 'kronika_api'

require_relative 'commands/command'
require_relative 'commands/convert_time_command'
require_relative 'commands/read_timezone_command'
require_relative 'commands/save_timezone_command'
require_relative 'commands/drop_timezone_command'
require_relative 'commands/send_help_message_command'
require_relative 'commands/send_location_sharing_request_command'
require_relative 'commands/command_builder'

class Webhook
  def initialize(config)
    self.config = config
  end

  def command(headers:, body:)
    verify_request_authenticity!(headers)

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
    GeoNames::Timezone::Api.new(config.geo_names_username)
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
