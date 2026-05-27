# frozen_string_literal: true

WebhookConfig = Data.define(
  :geo_names_username,
  :telegram_bot_token,
  :telegram_webhook_secret_token,
  :upstash_token,
  :upstash_url
)

class WebhookConfig
  ConfigEntry = Data.define(:name)

  class ConfigEntry
    def read_from_env
      key = env_var_name
      value = ENV.fetch(key, nil)

      raise "Error: #{key} environment variable must be set" if value.nil?
      raise "Error: #{key} environment variable cannot be empty" if value == ''

      value
    end

    private

    def env_var_name
      name.to_s.upcase
    end
  end

  class << self
    def load_from_env(&)
      attrs = read_from_env(&)

      new(**attrs)
    end

    private

    def entries
      members.map { |m| ConfigEntry.new(m) }
    end

    def read_from_env(&)
      entries.to_h { |e| [e.name, e.read_from_env] }
    rescue StandardError => e
      yield(e) if block_given?
    end
  end
end
