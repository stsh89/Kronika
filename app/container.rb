# frozen_string_literal: true

module Kronika
  class Container
    def initialize(upstash:, geo_names:, global_time:)
      @storage = StorageService.new(upstash)
      @geolocation = GeolocationService.new(geo_names)
      @global_time = GlobalTimeService.new(global_time)
    end

    def save_timezone
      SaveTimezoneOperation.new(storage:, geolocation:, global_time:)
    end

    def read_timezone
      ReadTimezoneOperation.new(storage:)
    end

    def drop_timezone
      DropTimezoneOperation.new(storage:)
    end

    def convert_time
      ConvertTimeOperation.new(storage:, global_time:)
    end

    private

    attr_reader :storage, :geolocation, :global_time
  end
end
