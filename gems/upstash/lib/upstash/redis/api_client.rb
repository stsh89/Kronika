# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Upstash
  module Redis
    class ApiClient < Async::HTTP::Client
      def initialize(base_url, token)
        endpoint = Async::HTTP::Endpoint.parse(base_url)
        super(endpoint)

        self.token = token
        self.timeout = 3
      end

      def call(request)
        request.headers.set('Authorization', "Bearer #{token}")

        Async::Task.current.with_timeout(timeout) do
          super(request)
        end
      end

      private

      attr_accessor :token, :timeout
    end
  end
end
