# frozen_string_literal: true

class ReadTimezoneCommand < Command
  def execute
    timezone = kronika_api.read_timezone(user_id:)

    if timezone
      send_text("Your time zone is set to #{timezone.id}.")
    else
      send_text("You haven't set a time zone yet. Use /set to set it.")
    end
  end
end
