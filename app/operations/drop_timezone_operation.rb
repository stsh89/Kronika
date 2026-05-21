# frozen_string_literal: true

module Kronika
  class DropTimezoneOperation
    def initialize(repo:)
      @repo = repo
    end

    def execute(user_id:)
      repo.delete_user(user_id)
    end

    private

    attr_reader :repo
  end
end
