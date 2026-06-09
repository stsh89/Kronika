# frozen_string_literal: true

module HttpMock
  MockResponse = Data.define(:body, :status, :headers)

  class MockResponse
    class << self
      def from_defaults(attrs)
        defaults = { status: 200, body: nil, headers: {} }
        defaults.update(attrs)
        MockResponse.new(**defaults)
      end
    end

    def into_http_response
      ::Protocol::HTTP::Response[
        status,
        headers,
        body ? [body] : []
      ]
    end
  end
end
