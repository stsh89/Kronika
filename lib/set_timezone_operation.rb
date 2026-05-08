class SetTimezoneOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute(timezone_identifier)
        begin
            timezone = Timezone.new(timezone_identifier)
            chat_timezones = @storage_service.get_chat_timezones(@chat)
            chat_timezones[@user.username] = timezone
            @storage_service.save_chat_timezones(@chat, chat_timezones)
            @notification_service.send_message(@chat, "Your timezone has been set to #{timezone.identifier}.")
        rescue InvalidArgumentError => e
            @notification_service.send_message(@chat, "Invalid timezone identifier: #{timezone_identifier}. Please provide a valid timezone.")
        end
    end
end