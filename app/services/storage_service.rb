# frozen_string_literal: true

module Kronika
  class StorageService
    def initialize(client)
      @client = client
    end

    def get_user(user_id)
      tz_identifier = @client.get_key("user:#{user_id}:timezone")

      raise NotFoundError, "User #{user_id}" if tz_identifier.nil?

      User.new(
        id: user_id,
        timezone: Timezone.new(tz_identifier)
      )
    end

    def save_user(user)
      @client.set_key("user:#{user.id}:timezone", user.timezone.identifier)
    end

    def delete_user(user_id)
      @client.delete_key("user:#{user_id}:timezone")
    end
  end
end
