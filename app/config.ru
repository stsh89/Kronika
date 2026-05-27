# frozen_string_literal: true

require_relative 'webhook'
require_relative 'webhook_config'

require 'async'
require 'console'
require 'rack'

config =
  begin
    WebhookConfig.load_from_env!
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
