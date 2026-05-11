# frozen_string_literal: true

module Kronika
  class RemoveTimezoneOperation
    def initialize(chat_id, username, services)
      @chat_id = chat_id
      @username = username
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute
      chat = @storage_service.get_chat(@chat_id)

      if chat.users.delete(@username)
        @storage_service.save_chat(chat)
        @notification_service.send_message(chat, 'Your timezone has been removed.')
      else
        @notification_service.send_message(chat, "You don't have a timezone set to remove.")
      end
    end
  end
end
