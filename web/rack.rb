# frozen_string_literal: true

require 'async'
require 'console'
require 'rack'

require_relative 'lib'

module Web
  Rack = ::Rack::Builder.new do
    config = Config.load_from_env do |err|
      Console.error(err.message, err)
      exit(1)
    end

    webhook_controller = WebhookController.new(config)

    map('/webhook') { run webhook_controller }
    run ->(_env) { [404, {}, []] }
  end
end
