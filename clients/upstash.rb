# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Upstash
  class RedisApi
    def initialize(base_url, token)
      endpoint = Async::HTTP::Endpoint.parse(base_url)

      @token = token
      @client = Async::HTTP::Client.new(endpoint)
    end

    def get_hash(key)
      path = "/get/#{key}"
      headers = { authorization: "Bearer #{@token}" }
      response = @client.get(path, headers)

      raise RedisApiError.from_response(response) unless response.success?

      response = get(path, headers)
      body = response.read
      result = JSON.parse(body)['result']

      return {} if result.nil?

      JSON.parse(result).to_h
    end

    def set_hash(key, value)
      path = "/set/#{key}"
      headers = { authorization: "Bearer #{@token}" }
      response = @client.post(path, headers, [value.to_json])

      return if response.success?

      raise RedisApiError.from_response(response)
    end
  end

  class RedisApiError < StandardError
    class << self
      def from_response(response)
        message = {
          error: 'Upstash Redis API error.',
          status: response.status,
          body: response.body.read,
          headers: response.headers.to_h
        }

        new(message.to_json)
      end
    end
  end
end
