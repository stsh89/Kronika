# frozen_string_literal: true

module Kronika
  class RemoveTimezoneOperation
    def initialize(services)
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute(chat_id:, chat_type:, user_id:)
      chat = Chat.new(id: chat_id, chat_type:)

      @storage_service.delete_user(user_id)
      @notification_service.send_message(chat, 'Your time zone has been removed.')
    end
  end
end
