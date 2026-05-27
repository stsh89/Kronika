# frozen_string_literal: true

require_relative 'api_client'
require_relative 'api_error'

require 'json'

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

        raise ApiError.from_response(response) unless response.success?
      ensure
        response&.close
      end

      private

      attr_accessor :client
    end
  end
end
