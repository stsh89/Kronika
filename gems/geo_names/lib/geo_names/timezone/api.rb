# frozen_string_literal: true

require_relative 'api_client'

require 'kronika/http'
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

        unless response.success?
          raise Kronika::Http::ApiIntegrationError.new(
            message: 'GeoNames API /timezoneJSON server error',
            response:
          )
        end

        body = response.body.read
        payload = JSON.parse(body)

        if payload['status']
          raise Kronika::Http::ApiIntegrationError.new(
            message: 'GeoNames API /timezoneJSON status error',
            response:
          )
        end

        payload['timezoneId']
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
