# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Telegram
  class BotApi
    BASE_URL = 'https://api.telegram.org'
    REQUEST_TIMEOUT_IN_SECONDS = 3

    def initialize(token)
      endpoint = Async::HTTP::Endpoint.parse(BASE_URL)

      @token = token
      @client = Async::HTTP::Client.new(endpoint)
    end

    def send_message(chat_id, text, options = {})
      path = "/bot#{@token}/sendMessage"
      body = { chat_id: chat_id, text: text, **options }
      headers = { 'Content-Type': 'application/json' }

      post(path, headers, body.to_json)
    end

    private

    def post(path, headers, body)
      Async::Task.current.with_timeout(REQUEST_TIMEOUT_IN_SECONDS) do
        response = @client.post(path, headers, [body])

        return response if response.success?

        raise BotApiError.from_response(response)
      end
    end
  end

  class BotApiError < StandardError
    class << self
      def from_response(response)
        message = {
          error: 'Telegram bot API error.',
          status: response.status,
          body: response.body.read,
          headers: response.headers.to_h
        }

        new(message.to_json)
      end
    end
  end
end
