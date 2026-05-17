# frozen_string_literal: true

require_relative 'web/web'

$stdout.sync = true

begin
  server = Web::Server.initialize!
rescue StandardError => e
  puts e.message
  puts e.full_message

  exit(1)
end

run do |env|
  begin
    request = Rack::Request.new(env)

    path = request.path
    request_method = request.request_method
    body = request.body.nil? ? '' : request.body.read
    headers = request.env.select { |k, _v| k.start_with?('HTTP_') }
    request = Web::Request.new(path:, request_method:, body:, headers:)

    server.handle(request)
  rescue StandardError => e
    puts e.message
    puts e.full_message
  end

  [200, {}, []]
end
