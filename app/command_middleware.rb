# frozen_string_literal: true

require_relative 'commands/command'
require_relative 'commands/convert_time_command'
require_relative 'commands/read_timezone_command'
require_relative 'commands/save_timezone_command'
require_relative 'commands/drop_timezone_command'
require_relative 'commands/send_help_message_command'
require_relative 'commands/send_location_sharing_request_command'
require_relative 'commands/command_builder'

require 'json'
require 'console'

class CommandMiddleware
  def initialize(app, services)
    self.app = app
    self.kronika_api = services.kronika_api
    self.bot_api = services.bot_api
  end

  def call(env)
    command = command(env)
    command ? app.call(command) : [200, {}, []]
  end

  private

  attr_accessor :app, :kronika_api, :bot_api

  def command(env)
    req = Rack::Request.new(env)
    body = req.body.read
    payload = JSON.parse(body, symbolize_names: true)
    Command.from_payload(payload:, bot_api:, kronika_api:)
  rescue StandardError => e
    Console.error(e.message, e)
  end
end
