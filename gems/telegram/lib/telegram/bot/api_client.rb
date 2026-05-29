# frozen_string_literal: true

require 'kronika/http'

module Telegram
  module Bot
    class ApiClient < Kronika::Http::Client
      BASE_URL = 'https://api.telegram.org'

      def initialize(token)
        super(base_url: BASE_URL, timeout: 3)

        self.token = token
      end

      def call(request)
        request.headers.set('Content-Type', 'application/json')
        request.path = "/bot#{token}#{request.path}"

        super
      end

      private

      attr_accessor :token
    end
  end
end
