# frozen_string_literal: true

module Web
  Config = Data.define(
    :geo_names_username,
    :telegram_bot_token,
    :telegram_webhook_secret_token,
    :upstash_token,
    :upstash_url
  )

  class Config
    class << self
      def load_from_env!
        new(
          geo_names_username: get_env!('GEO_NAMES_USERNAME'),
          telegram_bot_token: get_env!('TELEGRAM_BOT_TOKEN'),
          telegram_webhook_secret_token: get_env!('TELEGRAM_WEBHOOK_SECRET_TOKEN'),
          upstash_token: get_env!('UPSTASH_TOKEN'),
          upstash_url: get_env!('UPSTASH_URL')
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
end
