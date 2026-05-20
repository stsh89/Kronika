# frozen_string_literal: true

module Web
  class WebhookController
    def initialize(secret_token:, telegram_bot_api:, container:)
      @secret_token = secret_token
      @telegram_bot_api = telegram_bot_api
      @container = container
    end

    def execute(payload:, headers:)
      verify_request_authenticity!(headers)

      Telegram::Command.from_payload(payload:, container:, bot_api: telegram_bot_api).execute
    end

    private

    attr_reader :telegram_bot_api, :container, :secret_token

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']

      raise 'Missing Telegram webhook secret token' if got.to_s.empty?
      raise 'Invalid Telegram webhook secret token' if got != secret_token
    end
  end
end
