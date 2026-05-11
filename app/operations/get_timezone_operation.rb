module Kronika
    class GetTimezoneOperation
        def initialize(chat_id, username, services)
            @chat_id = chat_id
            @username = username
            @storage_service = services[:storage]
            @notification_service = services[:notification]
        end

        def execute
            begin
                chat = @storage_service.get_chat(@chat_id)
                user = chat.get_user(@username)
                @notification_service.send_message(chat, "Your timezone is set to #{user.timezone}.")
            rescue NotFoundError => e
                @notification_service.send_message(chat, "You haven't set a timezone yet. Use /set to set it.")
            end
        end
    end
end