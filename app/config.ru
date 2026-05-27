# frozen_string_literal: true

require_relative 'webhook'
require_relative 'webhook_config'

require 'rack'

config = WebhookConfig.load_from_env do |err|
  Console.error(err.message, err)
  exit(1)
end

webhook = Webhook.new(config)

app = Rack::Builder.new do
  map('/webhook') do
    run do |env|
      begin
        req = Rack::Request.new(env)
        headers = req.env.select { |k, _v| k.start_with?('HTTP_') }
        body = req.body&.read
        command = webhook.command(headers:, body:)

        Async do
          command&.execute
        rescue StandardError => e
          Console.error(e.message, e)
        end
      rescue StandardError => e
        Console.error(e.message, e)
      end

      [200, {}, []]
    end
  end

  run ->(_env) { [404, {}, []] }
end

run app
