# frozen_string_literal: true

require_relative 'http_mock_test_helper'

require 'faraday'
require 'json'

class MockServerVerifyTest < Minitest::Test
  attr_accessor :mock_server

  def setup
    self.mock_server = HttpMock::MockServer.start
  end

  def url
    mock_server.url
  end

  def client
    Faraday.new(url:)
  end

  def test_verify_successfully
    mock_server.mock(
      req: { verb: 'GET', path: '/translate' },
      res: { status: 200 }
    )

    client.get('/translate')

    mock_server.verify!
  end
end
