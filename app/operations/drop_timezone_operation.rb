# frozen_string_literal: true

module Kronika
  class RemoveTimezoneOperation
    def initialize(storage:)
      @storage = storage
    end

    def execute(user_id:)
      storage.delete_user(user_id)
    end

    private

    attr_reader :storage
  end
end
