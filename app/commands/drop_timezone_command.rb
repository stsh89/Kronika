# frozen_string_literal: true

class DropTimezoneCommand < Command
  def execute
    kronika_api.drop_timezone(user_id:)
    send_text('Your time zone has been removed.')
  end
end
