# frozen_string_literal: true

module Telegram
  class ReadTimezoneCommand < Command
    def execute
      timezone = kronika_api.read_timezone.execute(tenant_name:, identity_badges:)

      if timezone
        send_text("Your time zone is set to #{timezone.id}.")
      else
        send_text("You haven't set a time zone yet. Use /set to set it.")
      end
    end
  end
end
