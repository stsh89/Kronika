# frozen_string_literal: true

module Kronika
  class ConvertTimeOperation
    def initialize(repo:, global_time:)
      @repo = repo
      @global_time = global_time
    end

    def execute(user_id:, hour:, minutes:)
      user = repo.get_user(user_id)

      return unless user

      global_time.get_timestamp(hour, minutes, user.timezone)
    end

    private

    attr_reader :repo, :global_time
  end
end
