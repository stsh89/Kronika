# frozen_string_literal: true

module Kronika
  class Container
    def initialize(persistence:, geolocation:, clock:)
      @repo = Repository.new(persistence)
      @chrono = Chrono.new(geolocation:, clock:)
    end

    def save_timezone
      SaveTimezoneOperation.new(repo:, chrono:)
    end

    def read_timezone
      ReadTimezoneOperation.new(repo:)
    end

    def drop_timezone
      DropTimezoneOperation.new(repo:)
    end

    def convert_time
      ConvertTimeOperation.new(repo:, chrono:)
    end

    private

    attr_reader :repo, :chrono
  end
end
