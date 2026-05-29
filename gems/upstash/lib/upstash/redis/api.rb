# frozen_string_literal: true

require_relative 'api_client'

require 'json'
require 'kronika/http'

module Upstash
  module Redis
    class Api
      def initialize(base_url:, token:)
        self.client = ApiClient.new(base_url:, token:)
      end

      def get_key(key)
        path = "/get/#{key}"
        response = client.get(path)

        unless response.success?
          raise Kronika::Http::ApiIntegrationError.new(
            message: 'Upstash Redis API /get error',
            response:
          )
        end

        body = response.body.read
        JSON.parse(body)['result']
      ensure
        response&.close
      end

      def set_key(key, value)
        path = "/set/#{key}"
        response = client.post(path, {}, [value])

        unless response.success?
          raise Kronika::Http::ApiIntegrationError.new(
            message: 'Upstash Redis API /set error',
            response:
          )
        end
      ensure
        response&.close
      end

      def delete_key(key)
        path = "/del/#{key}"
        response = client.get(path)

        unless response.success?
          raise Kronika::Http::ApiIntegrationError.new(
            message: 'Upstash Redis API /del error',
            response:
          )
        end
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
