module Kronika
    class SetTimezoneOperation
        def initialize(chat_id, username, services)
            @chat_id = chat_id
            @username = username
            @storage_service = services[:storage]
            @notification_service = services[:notification]
        end

        def execute(tz_identifier)
            chat = @storage_service.get_chat(@chat_id)

            if tz_identifier == ''
                @notification_service.send_message(chat, "Missing time zone identifier. Please provide a valid time zone.")
                
                return
            end
            
            begin
                timezone = Timezone.new(tz_identifier)
                chat.users[@username] = User.new(username: @username, timezone: timezone)

                @storage_service.save_chat(chat)
                @notification_service.send_message(chat, "Your time zone has been set to #{timezone}.")
            rescue InvalidArgumentError => e
                @notification_service.send_message(chat, "Invalid time zone identifier: #{tz_identifier}. Please provide a valid time zone.")
            end
        end
    end
end