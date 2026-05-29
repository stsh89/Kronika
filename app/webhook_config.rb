# frozen_string_literal: true

WebhookConfig = Data.define(
  :geo_names_username,
  :telegram_bot_token,
  :telegram_webhook_secret_token,
  :upstash_token,
  :upstash_url
)

class WebhookConfig
  class << self
    def load_from_env
      WebhookConfig.new(
        geo_names_username: ENV.fetch('GEO_NAMES_USERNAME'),
        telegram_bot_token: ENV.fetch('TELEGRAM_BOT_TOKEN'),
        telegram_webhook_secret_token: ENV.fetch('TELEGRAM_WEBHOOK_SECRET_TOKEN'),
        upstash_token: ENV.fetch('UPSTASH_TOKEN'),
        upstash_url: ENV.fetch('UPSTASH_URL')
      )
    end
  end
end
