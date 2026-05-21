# frozen_string_literal: true

module Kronika
  AccessKey = Data.define(:tenant, :identity_badges)

  class AccessKey
    SEPARATOR = ':'

    def apply(&block)
      block.call(timezone_identity_label)
    end

    private

    def timezone_identity_label
      [
        tenant.name,
        identity_badges.join(SEPARATOR),
        :timezone
      ].join(SEPARATOR)
    end
  end
end
