# frozen_string_literal: true

module Kronika
  class ConvertTimeOperation
    def initialize(repo:, chrono:)
      @repo = repo
      @chrono = chrono
    end

    def execute(user_id:, hour:, minutes:)
      user = repo.get_user(user_id)

      return unless user

      chrono.get_timestamp(hour, minutes, user.timezone)
    end

    private

    attr_reader :repo, :chrono
  end
end
