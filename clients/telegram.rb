# frozen_string_literal: true

require 'async'
require 'async/http/client'
require 'async/http/endpoint'

module Telegram
  class BotApi
    def initialize(token)
      @client = BotApiClient.new(token)
    end

    def send_message(chat_id, text, options = {})
      path = '/sendMessage'
      body = { chat_id: chat_id, text: text, **options }
      response = client.post(path, {}, [body.to_json])

      raise BotApiError.from_response(response) unless response.success?
    ensure
      response&.close
    end

    private

    attr_reader :client
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

  class BotApiClient < Async::HTTP::Client
    BASE_URL = 'https://api.telegram.org'

    def initialize(token)
      endpoint = Async::HTTP::Endpoint.parse(BASE_URL)
      super(endpoint)

      @token = token
      @timeout = 3
    end

    def call(request)
      request.headers.set('Content-Type', 'application/json')
      request.path = "/bot#{token}#{request.path}"

      Async::Task.current.with_timeout(timeout) do
        super(request)
      end
    end

    private

    attr_reader :token, :timeout
  end
end
