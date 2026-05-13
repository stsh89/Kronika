# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Upstash
  class RedisApi
    def initialize(base_url, token)
      @client = RedisApiClient.new(base_url, token)
    end

    def get_hash(key)
      path = "/get/#{key}"
      response = @client.get(path)

      raise RedisApiError.from_response(response) unless response.success?

      body = response.body.read
      result = JSON.parse(body)['result']

      return {} if result.nil?

      JSON.parse(result).to_h
    end

    def set_hash(key, value)
      path = "/set/#{key}"
      response = @client.post(path, {}, [value.to_json])

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

  class RedisApiClient < Async::HTTP::Client
    def initialize(base_url, token)
      endpoint = Async::HTTP::Endpoint.parse(base_url)
      super(endpoint)

      @token = token
      @timeout = 3
    end

    def call(request)
      request.headers.set('Authorization', "Bearer #{@token}")

      Async::Task.current.with_timeout(@timeout) do
        super(request)
      end
    end
  end
end
