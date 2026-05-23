# frozen_string_literal: true

require 'json'
require 'time'

require_relative 'bot_api'

require_relative 'commands/command'
require_relative 'commands/convert_time_command'
require_relative 'commands/drop_timezone_command'
require_relative 'commands/read_timezone_command'
require_relative 'commands/save_timezone_command'
require_relative 'commands/send_help_message_command'
require_relative 'commands/send_location_sharing_request_command'

require_relative 'commands/command_builder'

module Telegram
  KRONIKA_API_TENANT_NAME = 'kronika'
  KRONIKA_API_SCOPE_BADGE = 'telegram'
  KRONIKA_API_USER_BADGE = 'user'
end
