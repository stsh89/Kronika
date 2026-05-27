# frozen_string_literal: true

WebhookConfig = Data.define(
  :geo_names_username,
  :telegram_bot_token,
  :telegram_webhook_secret_token,
  :upstash_token,
  :upstash_url
)
