# frozen_string_literal: true

module Kronika
  Timezone = Data.define(:identifier)

  class Timezone
    alias id identifier

    def initialize(identifier:)
      begin
        TZInfo::Timezone.get(identifier)
      rescue TZInfo::InvalidTimezoneIdentifier
        raise InvalidArgumentError, "Invalid time zone identifier: #{identifier}"
      end

      super
    end
  end
end
