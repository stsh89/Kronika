# frozen_string_literal: true

require_relative 'api_client'
require_relative 'api_error'

require 'json'

module Upstash
  module Redis
    class Api
      def initialize(base_url, token)
        self.client = ApiClient.new(base_url, token)
      end

      def get_key(key)
        path = "/get/#{key}"
        response = client.get(path)

        raise ApiError.from_response(response) unless response.success?

        body = response.body.read
        JSON.parse(body)['result']
      ensure
        response&.close
      end

      def set_key(key, value)
        path = "/set/#{key}"
        response = client.post(path, {}, [value])

        raise ApiError.from_response(response) unless response.success?
      ensure
        response&.close
      end

      def delete_key(key)
        path = "/del/#{key}"
        response = client.get(path)

        raise ApiError.from_response(response) unless response.success?
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
