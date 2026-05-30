# frozen_string_literal: true

require_relative 'clock'
require_relative 'kronika_api'

require 'telegram'
require 'upstash'
require 'geo_names'

module ServiceRegistry
  class Catalog
    class << self
      def build
        catalog = Catalog.new
        catalog.kronika_api = kronika_api
        catalog.bot_api = bot_api
        catalog
      end

      private

      def upstash
        base_url = APP_ENV['UPSTASH_URL']
        token = APP_ENV['UPSTASH_TOKEN']
        Upstash::Redis::Api.new(base_url:, token:)
      end

      def geo_names
        username = APP_ENV['GEO_NAMES_USERNAME']
        GeoNames::Timezone::Api.new(username)
      end

      def bot_api
        token = APP_ENV['TELEGRAM_BOT_TOKEN']
        Telegram::Bot::Api.new(token)
      end

      def kronika_api
        KronikaApi.new(
          geolocation: geo_names,
          persistence: upstash,
          clock:
        )
      end

      def clock
        Clock.new
      end
    end

    attr_accessor :kronika_api, :bot_api
  end
end
