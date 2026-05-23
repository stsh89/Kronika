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
      def load_from_env(&)
        attrs = members.to_h { |m| [m, get_env!(m.to_s.upcase)] }
        new(**attrs)
      rescue StandardError => e
        yield(e) if block_given?
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
