# frozen_string_literal: true

require_relative '../clients/geo_names'
require_relative '../clients/telegram'
require_relative '../clients/upstash'

require_relative '../app/lib'
require_relative 'config'
require_relative 'webhook_controller'

class Server
  def initialize(webhook_controller)
    @webhook_controller = webhook_controller
  end

  def router
    lambda do |env|
      request = Rack::Request.new(env)

      case request.path
      when '/webhook'
        case request.request_method
        when 'POST'
          begin
            headers = request.env.select { |k, _v| k.start_with?('HTTP_') }
            payload = JSON.parse(request.body.read, symbolize_names: true)

            @webhook_controller.execute(payload, headers)
          rescue StandardError => e
            puts e.message
            puts e.full_message
          end
        end
      end

      [200, {}, []]
    end
  end

  class << self
    def initialize!
      config = Config.load_from_env!
      telegram_client = Telegram::BotApi.new(config.telegram_bot_token)
      upstash_client = Upstash::RedisApi.new(config.upstash_url, config.upstash_token)
      geo_names_client = GeoNames::TimezoneApi.new(config.geo_names_username)

      attributes = {
        telegram_client:,
        upstash_client:,
        geo_names_client:,
        secret_token: config.telegram_webhook_secret_token
      }

      new(WebhookController.new(attributes))
    end
  end
end
