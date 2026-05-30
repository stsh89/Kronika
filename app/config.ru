# frozen_string_literal: true

require_relative 'middlewares/auth_middleware'
require_relative 'middlewares/command_middleware'
require_relative 'service_registry/catalog'

require 'async'
require 'console'
require 'kronika/http'
require 'rack'

begin
  APP_ENV = {
    'GEO_NAMES_USERNAME' => ENV.fetch('GEO_NAMES_USERNAME'),
    'UPSTASH_URL' => ENV.fetch('UPSTASH_URL'),
    'UPSTASH_TOKEN' => ENV.fetch('UPSTASH_TOKEN'),
    'TELEGRAM_BOT_TOKEN' => ENV.fetch('TELEGRAM_BOT_TOKEN'),
    'TELEGRAM_WEBHOOK_SECRET_TOKEN' => ENV.fetch('TELEGRAM_WEBHOOK_SECRET_TOKEN')
  }.freeze
rescue StandardError => e
  Console.error(e.message, e)
  exit(1)
end

app = Rack::Builder.new do
  services = ServiceRegistry::Catalog.build
  token = APP_ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']

  map('/webhook') do
    use AuthMiddleware, token
    use CommandMiddleware, services

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
