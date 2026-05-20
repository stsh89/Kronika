# frozen_string_literal: true

module Kronika
  class ConvertTimeOperation
    def initialize(storage:, global_time:)
      @storage = storage
      @global_time = global_time
    end

    def execute(user_id:, hour:, minutes:)
      user = storage.get_user(user_id)

      return unless user

      global_time.set_clock(hour, minutes, user.timezone)
    end

    private

    attr_reader :storage, :global_time
  end
end
