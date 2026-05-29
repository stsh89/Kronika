# frozen_string_literal: true

require_relative 'webhook'
require_relative 'webhook_config'
require_relative 'webhook_env'

require 'async'
require 'console'
require 'rack'
require 'kronika/http'

config = begin
  WebhookConfig.new(
    geo_names_username: WebhookEnv['GEO_NAMES_USERNAME'],
    telegram_bot_token: WebhookEnv['TELEGRAM_BOT_TOKEN'],
    telegram_webhook_secret_token: WebhookEnv['TELEGRAM_WEBHOOK_SECRET_TOKEN'],
    upstash_token: WebhookEnv['UPSTASH_TOKEN'],
    upstash_url: WebhookEnv['UPSTASH_URL']
  )
rescue StandardError => e
  Console.error(e.message, e)
  exit(1)
end

webhook = Webhook.new(config)

app = Rack::Builder.new do
  map('/webhook') do
    run do |env|
      req = Rack::Request.new(env)
      headers = req.env.select { |k, _v| k.start_with?('HTTP_') }
      body = req.body&.read

      command =
        begin
          webhook.command(headers:, body:)
        rescue Kronika::Http::ApiIntegrationError => e
          Console.error(e.message, e, **e.response_details)
        rescue StandardError => e
          Console.error(e.message, e)
        end

      Async do
        command&.execute
      rescue StandardError => e
        Console.error(e.message, e)
      end

      [200, {}, []]
    end
  end

  run ->(_env) { [404, {}, []] }
end

run app
