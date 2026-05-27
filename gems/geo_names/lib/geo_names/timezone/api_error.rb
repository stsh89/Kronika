# frozen_string_literal: true

module GeoNames
  module Timezone
    class ApiError < StandardError
      class << self
        def from_response(response)
          message = {
            error: 'GeoNames API error.',
            status: response.status,
            body: response.body&.read,
            headers: response.headers.to_h
          }

          new(message.to_json)
        end
      end
    end
  end
end
