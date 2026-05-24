# frozen_string_literal: true

require 'console'
require 'rack'

require_relative 'config'
require_relative 'controller'

module TelegramWebhook
  Rack = ::Rack::Builder.new do
    config = Config.load_from_env do |err|
      Console.error(err.message, err)
      exit(1)
    end

    controller = Controller.new(config)

    map('/webhook') { run controller }
    run ->(_env) { [404, {}, []] }
  end
end
