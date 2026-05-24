# frozen_string_literal: true

module Kronika
  AccessKey = Data.define(:key)

  class AccessKey
    def self.for_timezone(tenant:, identity_badges:)
      key = [tenant.name, *identity_badges, :timezone].join(':')
      new(key:)
    end

    def to_s = key
  end
end
