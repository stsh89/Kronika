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
    def load_from_env!
      attrs =
        members.to_h do |m|
          name = m.to_s.upcase
          value = ENV.fetch(name, nil)

          raise "Error: #{name} environment variable must be set" if value.nil?
          raise "Error: #{name} environment variable cannot be empty" if value == ''

          [m, value]
        end

      new(**attrs)
    end
  end
end
