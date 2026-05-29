# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Kronika
  module Http
    class Client < Async::HTTP::Client
      def initialize(base_url:, timeout:)
        super(Async::HTTP::Endpoint.parse(base_url))

        self.timeout = timeout
      end

      def call(request)
        Async::Task.current.with_timeout(timeout) do
          super(request)
        end
      end

      private

      attr_accessor :timeout
    end
  end
end
