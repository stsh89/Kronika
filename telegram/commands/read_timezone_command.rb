# frozen_string_literal: true

module Telegram
  class ReadTimezoneCommand < Command
    def execute
      user = container.read_timezone.execute(user_id:)

      if user
        send_text("Your time zone is set to #{user.timezone.id}.")
      else
        send_text("You haven't set a time zone yet. Use /set to set it.")
      end
    end
  end
end
