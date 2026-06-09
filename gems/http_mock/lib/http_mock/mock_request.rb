# frozen_string_literal: true

module HttpMock
  MockRequest = Data.define(:verb, :path, :headers, :body)

  class MockRequest
    class << self
      def from_http_request(req)
        headers = req.headers.to_a.each_with_object({}) do |pair, acc|
          key, value = pair
          acc[key] = value
        end

        MockRequest.new(
          verb: req.method,
          path: req.path,
          body: req.body&.read,
          headers:
        )
      end

      def from_defaults(attrs)
        defaults = { verb: 'GET', path: '/', body: nil, headers: {} }
        defaults.update(attrs)
        MockRequest.new(**defaults)
      end
    end

    def matches?(other)
      verb == other.verb &&
        path == other.path &&
        body == other.body &&
        headers_match?(other.headers)
    end

    private

    def headers_match?(other)
      other = other.transform_keys(&:downcase)

      headers.transform_keys(&:downcase).all? do |key, value|
        other[key] == value
      end
    end
  end
end
