# frozen_string_literal: true

require_relative 'http_mock_test_helper'

require 'faraday'

class MockServerStartTest < Minitest::Test
  attr_accessor :mock_server

  def setup
    self.mock_server = HttpMock::MockServer.start
  end

  def base_url
    mock_server.url
  end

  def test_get_request
    response = Faraday.get(base_url)

    assert_equal 404, response.status
    assert_equal 1, mock_server.requests.count
  end

  def test_post_request
    response = Faraday.post(base_url)

    assert_equal 404, response.status
    assert_equal 1, mock_server.requests.count
  end

  def test_delete_request
    response = Faraday.delete(base_url)

    assert_equal 404, response.status
    assert_equal 1, mock_server.requests.count
  end

  def test_patch_request
    response = Faraday.patch(base_url)

    assert_equal 404, response.status
    assert_equal 1, mock_server.requests.count
  end

  def test_put_request
    response = Faraday.put(base_url)

    assert_equal 404, response.status
    assert_equal 1, mock_server.requests.count
  end
end
