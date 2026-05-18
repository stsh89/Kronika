# frozen_string_literal: true

module Kronika
  class GetTimezoneOperation
    def initialize(services)
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute(chat_id:, chat_type:, user_id:)
      chat = Chat.new(id: chat_id, chat_type:)
      user = get_user(user_id)

      if user
        send_message(chat, "Your time zone is set to #{user.timezone.id}.")
      else
        send_message(chat, "You haven't set a time zone yet. Use /set to set it.")
      end
    end

    private

    def get_user(user_id)
      storage_service.get_user(user_id)
    rescue NotFoundError
      nil
    end

    def send_message(chat, message)
      @notification_service.send_message(chat, message)
    end
  end
end
