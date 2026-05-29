# frozen_string_literal: true

require_relative 'auth_middleware'
require_relative 'command_middleware'
require_relative 'kronika_api'

require 'async'
require 'console'
require 'geo_names'
require 'kronika/http'
require 'rack'
require 'telegram'
require 'upstash'

username = ENV.fetch('GEO_NAMES_USERNAME')
geolocation = GeoNames::Timezone::Api.new(username)
base_url = ENV.fetch('UPSTASH_URL')
token = ENV.fetch('UPSTASH_TOKEN')
persistence = Upstash::Redis::Api.new(base_url:, token:)
kronika_api = KronikaApi.new(geolocation:, persistence:)

token = ENV.fetch('TELEGRAM_BOT_TOKEN')
bot_api = Telegram::Bot::Api.new(token)

webhook_secret_token = ENV.fetch('TELEGRAM_WEBHOOK_SECRET_TOKEN')

app = Rack::Builder.new do
  map('/webhook') do
    use AuthMiddleware, webhook_secret_token
    use CommandMiddleware, { kronika_api:, bot_api: }

    run do |command|
      Async do
        command.execute
      rescue Kronika::Http::ApiIntegrationError => e
        Console.error(e.message, e, **e.response_details)
      rescue StandardError => e
        Console.error(e.message, e)
      end

      [200, {}, []]
    end
  end

  run ->(_env) { [404, {}, []] }
end

run app
