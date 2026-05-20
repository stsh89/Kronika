# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'
require 'json'

module GeoNames
  class TimezoneApi
    def initialize(username)
      @client = TimezoneApiClient.new(username)
    end

    def get_timezone_id(latitude:, longitude:)
      path = "/timezoneJSON?lat=#{latitude}&lng=#{longitude}"
      response = client.get(path, {})
      raise TimezoneApiError.from_response(response) unless response.success?

      body = response.body.read
      payload = JSON.parse(body)
      raise TimezoneApiError, "GeoNames API error: #{payload}" if payload['status']

      payload['timezoneId']
    ensure
      response&.close
    end

    private

    attr_reader :client
  end

  class TimezoneApiError < StandardError
    class << self
      def from_response(response)
        message = {
          error: 'GeoNames API error.',
          status: response.status,
          body: response.body.read,
          headers: response.headers.to_h
        }

        new(message.to_json)
      end
    end
  end

  class TimezoneApiClient < Async::HTTP::Client
    BASE_URL = 'https://secure.geonames.org'

    def initialize(username)
      endpoint = Async::HTTP::Endpoint.parse(BASE_URL)
      super(endpoint)

      @username = username
      @timeout = 3
    end

    def call(request)
      request.path = "#{request.path}&username=#{username}"

      Async::Task.current.with_timeout(timeout) do
        super(request)
      end
    end

    private

    attr_reader :username, :timeout
  end
end
