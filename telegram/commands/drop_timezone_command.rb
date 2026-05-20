# frozen_string_literal: true

module Telegram
  class DropTimezoneCommand < Command
    def execute
      drop_timezone
      send_text('Your time zone has been removed.')
    end

    private

    def drop_timezone
      services = { storage: Kronika::StorageService.new(upstash) }
      Kronika::DropTimezoneOperation.new(**services).execute(user_id:)
    end
  end
end
