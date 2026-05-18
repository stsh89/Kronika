# frozen_string_literal: true

module Kronika
  class NormalizeTimeOperation
    def initialize(chat_id, user_id, services)
      @chat = Chat.new(id: chat_id)
      @user_id = user_id
      @storage_service = services[:storage]
      @notification_service = services[:notification]
      @global_time_service = services[:global_time]
    end

    def execute(hour, minutes)
      user = @storage_service.get_user(@user_id)
      local_time = @global_time_service.get_local_time(hour, minutes, user.timezone)
      message = "#{local_time.tg_time}\n#{local_time.iana_time}"

      @notification_service.send_html_message(@chat, message)
    rescue NotFoundError
      # Do nothing if the user mentions a time without a time zone setting.
    end
  end
end
