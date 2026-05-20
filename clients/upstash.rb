# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Upstash
  class RedisApi
    def initialize(base_url, token)
      @client = RedisApiClient.new(base_url, token)
    end

    def get_key(key)
      path = "/get/#{key}"
      response = client.get(path)

      raise RedisApiError.from_response(response) unless response.success?

      body = response.body.read
      JSON.parse(body)['result']
    ensure
      response&.close
    end

    def set_key(key, value)
      path = "/set/#{key}"
      response = client.post(path, {}, [value])

      raise RedisApiError.from_response(response) unless response.success?
    ensure
      response&.close
    end

    def delete_key(key)
      path = "/del/#{key}"
      response = @client.get(path)

      raise RedisApiError.from_response(response) unless response.success?
    ensure
      response&.close
    end

    private

    attr_reader :client
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
      request.headers.set('Authorization', "Bearer #{token}")

      Async::Task.current.with_timeout(timeout) do
        super(request)
      end
    end

    private

    attr_reader :token, :timeout
  end
end
