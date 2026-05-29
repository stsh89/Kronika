# frozen_string_literal: true

module Kronika
  module Http
    class ApiIntegrationError < StandardError
      def initialize(message:, response:)
        super(message)

        self.body = response.body&.read
        self.headers = response.headers.to_h
        self.status = response.status
      end

      def response_details
        {
          body:,
          headers:,
          status:
        }
      end

      private

      attr_accessor :body, :headers, :status
    end
  end
end
