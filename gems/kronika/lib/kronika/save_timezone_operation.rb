# frozen_string_literal: true

module Kronika
  class SaveTimezoneOperation
    def initialize(repo:, chrono:)
      self.repo = repo
      self.chrono = chrono
    end

    def execute(tenant_name:, identity_badges:, timezone_id: nil, location: {})
      timezone = timezone_by_location(location) || timezone_by_id(timezone_id)
      return unless timezone

      tenant = Tenant.new(name: tenant_name)
      access_key = AccessKey.for_timezone(tenant:, identity_badges:)
      repo.save_timezone(access_key:, timezone:)
      timezone
    end

    private

    attr_accessor :repo, :chrono

    def timezone_by_location(location)
      return if location.empty?

      location = Location.new(**location)
      chrono.get_timezone_by_location(location)
    end

    def timezone_by_id(timezone_id)
      return unless timezone_id

      chrono.get_timezone_by_id(timezone_id)
    end
  end
end
