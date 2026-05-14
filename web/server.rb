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
            message = JSON.parse(request.body.read)
            headers = request.env.select { |k, _v| k.start_with?('HTTP_') }

            @webhook_controller.execute(message, headers)
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

      webhook_controller = WebhookController.new(
        telegram_client: telegram_client,
        upstash_client: upstash_client,
        secret_token: config.telegram_webhook_secret_token
      )

      new(webhook_controller)
    end
  end
end
