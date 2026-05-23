# frozen_string_literal: true

require 'async'
require 'console'
require 'rack'

require_relative 'lib'

module Web
  module Rack
    class Request
      def initialize(env)
        @inner = ::Rack::Request.new(env)
      end

      def into_web_request
        Web::Request.new(body:, headers:)
      end

      private

      attr_reader :inner

      def headers
        inner.env.select { |k, _v| k.start_with?('HTTP_') }
      end

      def body
        inner.body.nil? ? '' : inner.body.read
      end
    end

    App = ::Rack::Builder.new do
      config = Web::Config.load_from_env do |err|
        Console.error(err.message, err)
        exit(1)
      end

      webhook_controller = Web::WebhookController.new(config)

      map '/webhook' do
        run do |env|
          req = Web::Rack::Request.new(env).into_web_request

          Async do
            webhook_controller.execute(req)
          rescue StandardError => e
            Console.error(e.message, e)
          end

          [200, {}, []]
        end
      end

      run ->(_env) { [404, {}, []] }
    end
  end
end
