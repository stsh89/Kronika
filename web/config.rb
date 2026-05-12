# frozen_string_literal: true

Config = Data.define(:upstash_url, :upstash_token, :telegram_bot_token, :telegram_webhook_secret_token)

class Config
  class << self
    def load_from_env!
      new(
        telegram_bot_token: get_env!('TELEGRAM_BOT_TOKEN'),
        upstash_url: get_env!('UPSTASH_URL'),
        upstash_token: get_env!('UPSTASH_TOKEN'),
        telegram_webhook_secret_token: get_env!('TELEGRAM_WEBHOOK_SECRET_TOKEN')
      )
    end

    private

    def get_env!(name)
      value = ENV.fetch(name, nil)

      raise "Error: #{name} environment variable must be set" if value.nil?
      raise "Error: #{name} environment variable cannot be empty" if value == ''

      value
    end
  end
end
