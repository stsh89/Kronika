# frozen_string_literal: true

module Kronika
  class Repository
    def initialize(client)
      self.client = client
    end

    def get_timezone(access_key)
      id = client.get_key(access_key.to_s)
      Timezone.new(id:) if id
    end

    def save_timezone(access_key:, timezone:)
      client.set_key(access_key.to_s, timezone.id)
    end

    def delete_timezone(access_key)
      client.delete_key(access_key.to_s)
    end

    private

    attr_accessor :client
  end
end
