# frozen_string_literal: true

module Kronika
  class SaveTimezoneOperation
    def initialize(repo:, chrono:)
      @repo = repo
      @chrono = chrono
    end

    def execute(user_id:, input:)
      timezone = build_timezone(input)

      return unless timezone

      user = User.new(id: user_id, timezone:)
      repo.save_user(user)

      user
    end

    private

    attr_reader :repo, :chrono

    def build_timezone(input)
      case input
      in { timezone_id: }
        chrono.get_timezone_by_id(timezone_id)
      in { location: }
        location = Location.new(**location)
        chrono.get_timezone_by_location(location)
      end
    end
  end
end
