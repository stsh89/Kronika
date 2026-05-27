# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module GeoNames
  module Timezone
    class TimezoneApiClient < Async::HTTP::Client
      BASE_URL = 'https://secure.geonames.org'

      def initialize(username)
        endpoint = Async::HTTP::Endpoint.parse(BASE_URL)
        super(endpoint)

        self.username = username
        self.timeout = 3
      end

      def call(request)
        request.path = "#{request.path}&username=#{username}"

        Async::Task.current.with_timeout(timeout) do
          super(request)
        end
      end

      private

      attr_accessor :username, :timeout
    end
  end
end
