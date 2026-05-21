# frozen_string_literal: true

module Kronika
  class Repository
    def initialize(client)
      @client = client
    end

    def get_timezone(access_key)
      id = access_key.apply { |key| client.get_key(key) }

      Timezone.new(id:) if id
    end

    def save_timezone(access_key:, timezone:)
      access_key.apply { |key| client.set_key(key, timezone.id) }
    end

    def delete_timezone(access_key)
      access_key.apply { |key| client.delete_key(key) }
    end

    private

    attr_reader :client
  end
end
