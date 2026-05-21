# frozen_string_literal: true

module Kronika
  class Container
    def initialize(upstash:, geo_names:, global_time:)
      @repo = Repository.new(upstash)
      @geolocation = GeolocationService.new(geo_names)
      @global_time = GlobalTimeService.new(global_time)
    end

    def save_timezone
      SaveTimezoneOperation.new(repo:, geolocation:, global_time:)
    end

    def read_timezone
      ReadTimezoneOperation.new(repo:)
    end

    def drop_timezone
      DropTimezoneOperation.new(repo:)
    end

    def convert_time
      ConvertTimeOperation.new(repo:, global_time:)
    end

    private

    attr_reader :repo, :geolocation, :global_time
  end
end
