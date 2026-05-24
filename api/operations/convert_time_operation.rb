# frozen_string_literal: true

module Kronika
  class ConvertTimeOperation
    def initialize(repo:, chrono:)
      @repo = repo
      @chrono = chrono
    end

    def execute(tenant_name:, identity_badges:, hour:, minutes:)
      timezone = read_timezone(tenant_name:, identity_badges:)
      return unless timezone

      chrono.get_timestamp(hour, minutes, timezone)
    end

    private

    attr_reader :repo, :chrono

    def read_timezone(tenant_name:, identity_badges:)
      ReadTimezoneOperation
        .new(repo:)
        .execute(tenant_name:, identity_badges:)
    end
  end
end
