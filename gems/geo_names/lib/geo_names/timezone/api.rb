# frozen_string_literal: true

require_relative 'api_client'
require_relative 'api_error'

require 'json'

module GeoNames
  module Timezone
    class Api
      def initialize(username)
        self.client = ApiClient.new(username)
      end

      def get_timezone_id(latitude:, longitude:)
        path = "/timezoneJSON?lat=#{latitude}&lng=#{longitude}"
        response = client.get(path, {})
        raise ApiError.from_response(response) unless response.success?

        body = response.body.read
        payload = JSON.parse(body)
        raise ApiError, "GeoNames API error: #{payload}" if payload['status']

        payload['timezoneId']
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
