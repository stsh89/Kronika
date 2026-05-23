# frozen_string_literal: true

require 'async'
require 'console'
require 'rack'

require_relative 'lib'

module Web
  module Rack
    class Webhook
      def initialize(controller)
        @controller = controller
      end

      def call(env)
        Web::Rack::WebhookController
          .new(env)
          .execute_async(controller)
      end

      private

      attr_reader :controller
    end

    class WebhookController
      def initialize(env)
        @env = env
      end

      def execute_async(web_impl)
        execute_async_web(web_impl, web_request)

        [200, {}, []]
      end

      private

      attr_reader :env

      def execute_async_web(web_impl, web_request)
        Async do
          web_impl.execute(web_request)
        rescue StandardError => e
          Console.error(e.message, e)
        end
      end

      def web_request
        request = ::Rack::Request.new(env)
        body = request.body.nil? ? '' : request.body.read
        headers = request.env.select { |k, _v| k.start_with?('HTTP_') }

        Web::Request.new(body:, headers:)
      end
    end

    App = ::Rack::Builder.new do
      config = Web::Config.load_from_env do |err|
        Console.error(err.message, err)
        exit(1)
      end

      controller = Web::WebhookController.new(config)
      webhook = Web::Rack::Webhook.new(controller)

      map('/webhook') { run webhook }
      run ->(_env) { [404, {}, []] }
    end
  end
end
