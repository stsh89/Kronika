# frozen_string_literal: true

class WebhookEnv
  class << self
    def [](name)
      value = ENV.fetch(name, nil)

      raise "Error: #{name} environment variable must be set" if value.nil?
      raise "Error: #{name} environment variable cannot be empty" if value == ''

      value
    end
  end
end
