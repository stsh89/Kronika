# frozen_string_literal: true

require 'kronika/http'

module Upstash
  module Redis
    class ApiClient < Kronika::Http::Client
      def initialize(base_url:, token:)
        super(base_url:, timeout: 3)

        self.token = token
      end

      def call(request)
        request.headers.set('Authorization', "Bearer #{token}")

        super
      end

      private

      attr_accessor :token
    end
  end
end
