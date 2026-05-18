# frozen_string_literal: true

module Kronika
  class NormalizeTimeOperation
    def initialize(chat_id, user_id, services)
      @chat = Chat.new(id: chat_id)
      @user_id = user_id
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute(time_str)
      user = @storage_service.get_user(@user_id)
      local_time = LocalTime.from_string(time_str, user.timezone)
      message = "#{local_time.tg_time}\n#{local_time.iana_time}"

      @notification_service.send_html_message(@chat, message)
    rescue InvalidArgumentError
      # Do nothing in the case of an invalid time string, such as 12:60.
    rescue NotFoundError
      # Do nothing if the user mentions a time without a time zone setting.
    end
  end
end
