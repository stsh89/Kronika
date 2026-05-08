class GetTimezoneOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute
        begin
            timezone = @storage_service.get_user_timezone(@chat, @user)
            @notification_service.send_message(@chat, "Your timezone is set to #{timezone.identifier}.")
        rescue NotFoundError => e
            @notification_service.send_message(@chat, "You haven't set a timezone yet. Use /set to set it.")
        end
    end
end