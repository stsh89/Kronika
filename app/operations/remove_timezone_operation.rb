# frozen_string_literal: true

module Kronika
  class RemoveTimezoneOperation
    def initialize(chat_id, user_id, services)
      @chat = Chat.new(id: chat_id)
      @user_id = user_id
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute
      @storage_service.delete_user(@user_id)
      @notification_service.send_message(@chat, 'Your timezone has been removed.')
    end
  end
end
