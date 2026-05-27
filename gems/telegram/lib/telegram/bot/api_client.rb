# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Telegram
  module Bot
    class ApiClient < Async::HTTP::Client
      BASE_URL = 'https://api.telegram.org'

      def initialize(token)
        endpoint = Async::HTTP::Endpoint.parse(BASE_URL)
        super(endpoint)

        self.token = token
        self.timeout = 3
      end

      def call(request)
        request.headers.set('Content-Type', 'application/json')
        request.path = "/bot#{token}#{request.path}"

        Async::Task.current.with_timeout(timeout) do
          super(request)
        end
      end

      private

      attr_accessor :token, :timeout
    end
  end
end
