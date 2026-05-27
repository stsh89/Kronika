# frozen_string_literal: true

module Upstash
  module Redis
    class ApiError < StandardError
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
  end
end
