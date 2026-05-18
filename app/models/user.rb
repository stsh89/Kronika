# frozen_string_literal: true

module Kronika
  User = Data.define(:id, :timezone)

  class User
    def initialize(id:, timezone:)
      raise InvalidArgumentError, "User #{id} without time zone" if timezone.nil?

      super
    end
  end
end
