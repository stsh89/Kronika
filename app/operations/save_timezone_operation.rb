# frozen_string_literal: true

module Kronika
  class SaveTimezoneOperation
    def initialize(repo:, chrono:)
      @repo = repo
      @chrono = chrono
    end

    def execute(tenant_name:, identity_badges:, input:)
      timezone = build_timezone(input)
      return unless timezone

      tenant = Tenant.new(name: tenant_name)
      access_key = AccessKey.for_timezone(tenant:, identity_badges:)
      repo.save_timezone(access_key:, timezone:)
      timezone
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
