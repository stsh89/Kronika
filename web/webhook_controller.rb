# frozen_string_literal: true

module Web
  class WebhookController
    def initialize(secret_token:, clients:)
      @secret_token = secret_token
      @clients = clients
    end

    def execute(payload:, headers:)
      verify_request_authenticity!(headers)

      Command.from_payload(payload:, clients:).execute
    end

    private

    attr_reader :clients, :secret_token

    def verify_request_authenticity!(headers)
      got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']

      raise 'Missing Telegram webhook secret token' if got.to_s.empty?
      raise 'Invalid Telegram webhook secret token' if got != secret_token
    end
  end
end
