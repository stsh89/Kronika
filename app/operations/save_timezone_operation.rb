# frozen_string_literal: true

module Kronika
  class SaveTimezoneOperation
    def initialize(storage:, geolocation:, global_time:)
      @storage = storage
      @geolocation = geolocation
      @global_time = global_time
    end

    def execute(user_id:, input:)
      timezone = build_timezone(input)

      return unless timezone

      user = User.new(id: user_id, timezone:)
      storage.save_user(user)

      user
    end

    private

    attr_reader :storage, :geolocation, :global_time

    def build_timezone(input)
      case input
      in { timezone_id: }
        global_time.get_timezone(timezone_id)
      in { location: }
        location = Location.new(**location)
        geolocation.get_timezone(location)
      end
    end
  end
end
