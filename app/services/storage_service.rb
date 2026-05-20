# frozen_string_literal: true

module Kronika
  class StorageService
    def initialize(client)
      @client = client
    end

    def get_user(id)
      timezone = get_timezone(id)

      return unless timezone

      User.new(id:, timezone:)
    end

    def save_user(user)
      client.set_key("user:#{user.id}:timezone", user.timezone.id)
    end

    def delete_user(id)
      client.delete_key("user:#{id}:timezone")
    end

    private

    def get_timezone(user_id)
      id = client.get_key("user:#{user_id}:timezone")

      return unless id

      Timezone.new(id:)
    end

    attr_reader :client
  end
end
