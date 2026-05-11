# frozen_string_literal: true

module Kronika
  Timezone = Data.define(:identifier)

  class Timezone
    include Comparable

    def initialize(identifier:)
      begin
        TZInfo::Timezone.get(identifier)
      rescue TZInfo::InvalidTimezoneIdentifier
        raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
      end

      super
    end

    def to_s
      identifier
    end

    def <=>(other)
      return nil unless other.is_a?(Timezone)

      identifier <=> other.identifier
    end
  end
end
