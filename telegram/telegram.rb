# frozen_string_literal: true

require 'json'
require 'time'

require_relative '../app/lib'

require_relative 'bot_api'
require_relative 'commands/commands'
require_relative 'command_builder'

module Telegram
  TENANT_NAME = :kronika
  SCOPE_BADGE = :telegram
  UNIT_BADGE = :user
end
