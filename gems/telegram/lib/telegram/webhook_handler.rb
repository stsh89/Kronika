# frozen_string_literal: true

require_relative 'commands/command'
require_relative 'commands/command_builder'
require_relative 'commands/convert_time_command'
require_relative 'commands/drop_timezone_command'
require_relative 'commands/read_timezone_command'
require_relative 'commands/save_timezone_command'
require_relative 'commands/send_help_message_command'
require_relative 'commands/send_location_sharing_request_command'

module Telegram
  WebhookHandler = Data.define(
    :payload,
    :headers,
    :secret_token,
    :bot_api,
    :kronika_api
  )

  class WebhookHandler
    def handle
      verify_request_authenticity!

      Command.from_payload(
        payload:,
        bot_api:,
        kronika_api:
      )&.execute
    end

    private

    def verify_request_authenticity!
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']

      raise 'Missing Telegram webhook secret token' if got.to_s.empty?
      raise 'Invalid Telegram webhook secret token' if got != secret_token
    end
  end
end
