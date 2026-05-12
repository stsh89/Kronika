# frozen_string_literal: true

require_relative 'web/server'

begin
  server = Server.initialize!
rescue StandardError => e
  puts e.message
  puts e.full_message

  exit(1)
end

run server.router
