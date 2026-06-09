# frozen_string_literal: true

require_relative 'mock_request'
require_relative 'mock_response'
require_relative 'mock_server_state'

require 'async'
require 'async/http/server'
require 'async/http/endpoint'

module HttpMock
  class MockServer
    class << self
      def start
        new.tap(&:start)
      end
    end

    def initialize
      self.host = '127.0.0.1'
      self.port = find_free_port
      self.state = MockServerState.new
    end

    def url
      "http://#{host}:#{port}"
    end

    def start
      endpoint = Async::HTTP::Endpoint.parse(url)

      Thread.new do
        Async do
          server =
            Async::HTTP::Server.for(endpoint) do |request|
              handle_request(request)
            end

          server.run
        end
      end

      wait_until_ready

      self
    end

    def mock(req:, res:)
      state.add_expectation(
        req: MockRequest.from_defaults(req),
        res: MockResponse.from_defaults(res)
      )
    end

    def verify!
      state.verify!
    end

    def requests
      state.requests
    end

    private

    attr_accessor :host, :port, :state

    def find_free_port(start_port = 10_000, max_port = 65_535)
      (start_port..max_port).each do |port|
        server = TCPServer.new('127.0.0.1', port)
        server.close
        return port
      rescue Errno::EADDRINUSE, Errno::EACCES
        next
      end

      raise "No free port found in range #{start_port}..#{max_port}"
    end

    def handle_request(req)
      req = MockRequest.from_http_request(req)

      state
        .handle_request(req)
        .into_http_response
    end

    def wait_until_ready
      Timeout.timeout(5) do
        loop do
          TCPSocket.new(host, port).close
          break
        rescue Errno::ECONNREFUSED
          sleep 0.01
        end
      end
    end
  end
end
