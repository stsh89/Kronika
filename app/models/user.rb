# frozen_string_literal: true

module Kronika
  User = Data.define(:id, :timezone)

  class User
    def initialize(id:, timezone:)
      raise InvalidArgumentError, "User ID can't be blank." if id.to_s.empty?
      raise InvalidArgumentError, "User time zone can't be blank. User #{id} without time zone." if timezone.nil?

      super
    end
  end
end
