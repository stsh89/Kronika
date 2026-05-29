# frozen_string_literal: true

require 'kronika/http'

module GeoNames
  module Timezone
    class ApiClient < Kronika::Http::Client
      BASE_URL = 'https://secure.geonames.org'

      def initialize(username)
        super(base_url: BASE_URL, timeout: 3)
        self.username = username
      end

      def call(request)
        request.path = "#{request.path}&username=#{username}"
        super
      end

      private

      attr_accessor :username
    end
  end
end
