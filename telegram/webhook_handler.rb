# frozen_string_literal: true

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
