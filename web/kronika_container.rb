# frozen_string_literal: true

module Web
  class KronikaContainer
    def initialize(persistence:, geolocation:, clock:)
      @repo = Kronika::Repository.new(persistence)
      @chrono = Kronika::Chrono.new(geolocation:, clock:)
    end

    def save_timezone
      Kronika::SaveTimezoneOperation.new(repo:, chrono:)
    end

    def read_timezone
      Kronika::ReadTimezoneOperation.new(repo:)
    end

    def drop_timezone
      Kronika::DropTimezoneOperation.new(repo:)
    end

    def convert_time
      Kronika::ConvertTimeOperation.new(repo:, chrono:)
    end

    private

    attr_reader :repo, :chrono
  end
end
