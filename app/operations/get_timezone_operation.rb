# frozen_string_literal: true

module Kronika
  class GetTimezoneOperation
    def initialize(chat_id, user_id, services)
      @chat = Chat.new(id: chat_id)
      @user_id = user_id
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute
      user = @storage_service.get_user(@user_id)
      @notification_service.send_message(@chat, "Your time zone is set to #{user.timezone.id}.")
    rescue NotFoundError
      @notification_service.send_message(@chat, "You haven't set a time zone yet. Use /set to set it.")
    end
  end
end
