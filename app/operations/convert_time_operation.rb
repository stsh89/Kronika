# frozen_string_literal: true

module Kronika
  class ConvertTimeOperation
    def initialize(repo:, chrono:)
      @repo = repo
      @chrono = chrono
    end

    def execute(tenant_name:, identity_badges:, hour:, minutes:)
      tenant = Tenant.new(name: tenant_name)
      access_key = AccessKey.new(tenant:, identity_badges:)
      timezone = repo.get_timezone(access_key)
      chrono.get_timestamp(hour, minutes, timezone) if timezone
    end

    private

    attr_reader :repo, :chrono
  end
end
