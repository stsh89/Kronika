# frozen_string_literal: true

module Telegram
  class ReadTimezoneCommand < Command
    def execute
      user = read_timezone

      if user
        send_text("Your time zone is set to #{user.timezone.id}.")
      else
        send_text("You haven't set a time zone yet. Use /set to set it.")
      end
    end

    private

    def read_timezone
      services = { storage: Kronika::StorageService.new(upstash) }
      Kronika::ReadTimezoneOperation.new(**services).execute(user_id:)
    end
  end
end
