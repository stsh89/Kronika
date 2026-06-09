# frozen_string_literal: true

require_relative 'http_mock_test_helper'

require 'faraday'
require 'json'

class MockServerMockTest < Minitest::Test
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

  def test_mock_get_request
    mock_server.mock(
      req: {
        verb: 'GET',
        path: '/translate?word=hello'
      },
      res: {
        status: 200,
        body: 'ohi',
        headers: { 'content-type' => 'text/html' }
      }
    )

    response = client.get('/translate', { word: 'hello' })

    assert_equal 'text/html', response.headers['content-type']
    assert_equal 200, response.status
    assert_equal 'ohi', response.body
  end

  def test_mock_api_token_header_request
    mock_server.mock(
      req: {
        verb: 'GET',
        path: '/translate?word=hello',
        headers: { 'api-token' => '7i3gxz88' }
      },
      res: {
        status: 200,
        body: 'ohi',
        headers: { 'content-type' => 'text/html' }
      }
    )

    response = client.get(
      '/translate',
      { word: 'hello' },
      { 'api-token' => '7i3gxz88' }
    )

    assert_equal 'text/html', response.headers['content-type']
    assert_equal 200, response.status
    assert_equal 'ohi', response.body
  end

  def test_mock_post_request
    mock_server.mock(
      req: { verb: 'POST', path: '/translate', body: { word: 'hello' }.to_json },
      res: { status: 200, body: { word: 'ohi' }.to_json }
    )

    response = client.post('/translate', { word: 'hello' }.to_json)

    assert_equal 200, response.status
    assert_equal({ word: 'ohi' }.to_json, response.body)
  end
end
