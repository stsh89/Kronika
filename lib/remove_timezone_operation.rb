class RemoveTimezoneOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute
        chat_timezones = @storage_service.get_chat_timezones(@chat)

        if chat_timezones.delete(@user.username)
            @storage_service.save_chat_timezones(@chat, chat_timezones)
            @notification_service.send_message(@chat, "Your timezone has been removed.")
        else
            @notification_service.send_message(@chat, "You don't have a timezone set to remove.")
        end
    end
end