# frozen_string_literal: true

require 'console'
require 'rack'

require_relative 'config'
require_relative 'webhook'

module TelegramWebhook
  Rack = ::Rack::Builder.new do
    config = Config.load_from_env do |err|
      Console.error(err.message, err)
      exit(1)
    end

    webhook = Webhook.new(config)

    map('/webhook') do
      run do |env|
        req = ::Rack::Request.new(env)
        command = webhook.command(req)

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
end
