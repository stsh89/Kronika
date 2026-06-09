# frozen_string_literal: true

require_relative 'mock_response'

require 'async'
require 'async/http/server'
require 'async/http/endpoint'

module HttpMock
  class MockServerState
    def initialize
      self.unmatched_requests = []
      self.expectations = []
    end

    def add_expectation(req:, res:)
      expectations << { req:, res: }
    end

    def verify!
      error_message = build_verification_error_message
      return unless error_message

      raise "\n\nFound unmatched requests:\n\n#{error_message}"
    end

    def handle_request(req)
      expectations.each do |exp|
        next unless exp[:req].matches?(req)

        exp[:match] = req
        return exp[:res]
      end

      unmatched_requests << req
      MockResponse.new(status: 404, body: nil, headers: {})
    end

    def requests
      acc = []

      acc.concat(unmatched_requests)

      expectations.each do |exp|
        acc << exp if exp[:match]
      end

      acc
    end

    private

    attr_accessor :unmatched_requests, :expectations

    def unmatched_expectations
      expectations.select { |exp| exp[:match].nil? }
    end

    def find_match(req)
      journal.each do |entry|
        res = entry[:res]

        next if res.nil?
        next unless entry[:req].matches?(req)

        return entry
      end
    end

    def build_verification_error_message
      msg = []

      msg.concat(unmatched_expectations_error_message)
      msg.concat(unmatched_requests_error_message)

      msg.empty? ? nil : msg.join("\n")
    end

    def unmatched_expectations_error_message
      msg = []

      unmatched_expectations.each do |exp|
        req = exp[:req]

        msg << '[EXPECTED]'
        msg << "#{req.verb} #{req.path}"
        msg << "Headers: #{req.headers}" unless req.headers.empty?
        msg << "Body: #{req.body}" if req.body
        msg << ''
      end

      msg
    end

    def unmatched_requests_error_message
      msg = []

      unmatched_requests.each do |req|
        msg << '[ACTUAL]'
        msg << "#{req.verb} #{req.path}"
        msg << "Headers: #{req.headers}" unless req.headers.empty?
        msg << "Body: #{req.body}" if req.body
        msg << ''
      end

      msg
    end
  end
end
