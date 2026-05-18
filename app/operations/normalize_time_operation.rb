# frozen_string_literal: true

module Kronika
  class NormalizeTimeOperation
    def initialize(services)
      @storage_service = services[:storage]
      @notification_service = services[:notification]
      @global_time_service = services[:global_time]
    end

    def execute(chat_id:, chat_type:, user_id:, hour:, minutes:)
      chat = Chat.new(id: chat_id, chat_type:)
      user = get_user(user_id)

      return unless user

      local_time = @global_time_service.get_local_time(hour, minutes, user.timezone)
      message = "#{local_time.tg_time}\n#{local_time.iana_time}"

      @notification_service.send_html_message(chat, message)
    end

    private

    def get_user(user_id)
      @storage_service.get_user(user_id)
    rescue NotFoundError
      nil
    end
  end
end
