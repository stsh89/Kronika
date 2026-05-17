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
        attrs = Config.members.each_with_object({}) do |name, acc|
          acc[name] = get_env!(name.to_s.upcase)
        end

        new(**attrs)
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
