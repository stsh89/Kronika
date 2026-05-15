# frozen_string_literal: true

module Kronika
  Timezone = Data.define(:identifier)

  class Timezone
    def initialize(identifier:)
      begin
        TZInfo::Timezone.get(identifier)
      rescue TZInfo::InvalidTimezoneIdentifier
        raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
      end

      super
    end
  end
end
