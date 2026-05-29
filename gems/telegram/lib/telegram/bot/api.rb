# frozen_string_literal: true

require_relative 'api_client'

require 'json'
require 'kronika/http'

module Telegram
  module Bot
    class Api
      def initialize(token)
        self.client = ApiClient.new(token)
      end

      def send_message(chat_id, text, options = {})
        path = '/sendMessage'
        body = { chat_id: chat_id, text: text, **options }
        response = client.post(path, {}, [body.to_json])

        return if response.success?

        raise Kronika::Http::ApiIntegrationError.new(
          message: 'Telegram bot API /sendMessage error',
          response:
        )
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
