# frozen_string_literal: true

module Kronika
  class DropTimezoneOperation
    def initialize(repo:)
      self.repo = repo
    end

    def execute(tenant_name:, identity_badges:)
      tenant = Tenant.new(name: tenant_name)
      access_key = AccessKey.for_timezone(tenant:, identity_badges:)
      repo.delete_timezone(access_key)
    end

    private

    attr_accessor :repo
  end
end
