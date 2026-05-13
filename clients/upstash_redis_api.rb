# frozen_string_literal: true

require 'async'
require 'async/http/internet'

class UpstashRedisAPI
  def initialize(url, token)
    @url = url
    @headers = { authorization: "Bearer #{token}" }
    @request_timeout_in_seconds = 3
  end

  def get_hash(key)
    url = "#{@url}/get/#{key}"
    internet = Async::HTTP::Internet.new

    begin
      response = Async::Task.current.with_timeout(@request_timeout_in_seconds) do
        internet.get(url, @headers)
      end

      raise "Upstash API error. Status: #{response.status}. Body: #{response.read}" unless response.success?

      body = response.read
      result = JSON.parse(body)['result']

      return {} if result.nil?

      JSON.parse(result).to_h
    ensure
      internet.close
    end
  end

  def set_hash(key, value)
    url = "#{@url}/set/#{key}"
    internet = Async::HTTP::Internet.new

    begin
      Async::Task.current.with_timeout(@request_timeout_in_seconds) do
        internet.post(url, @headers, [value.to_json])
      end
    ensure
      internet.close
    end
  end
end
