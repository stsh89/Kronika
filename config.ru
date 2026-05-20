# frozen_string_literal: true

require_relative 'web/web'

config =
  begin
    Web::Config.load_from_env!
  rescue StandardError => e
    Console.error(e.message, e)
    exit(1)
  end

server = Web::Server.new(config)

def web_request_from_env(env)
  request = Rack::Request.new(env)

  path = request.path
  verb = request.request_method
  body = request.body.nil? ? '' : request.body.read
  headers = request.env.select { |k, _v| k.start_with?('HTTP_') }

  Web::Request.new(path:, verb:, body:, headers:)
end

run do |env|
  begin
    req = web_request_from_env(env)

    server.handle(req)
  rescue StandardError => e
    Console.error(e.message, e)
  end

  [200, {}, []]
end
