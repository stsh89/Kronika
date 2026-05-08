class CreateTimeBoardOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @time_service = services[:time]
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute(time)
        chat_timezone_settings = @storage_service.get_chat_timezone_settings(@chat)

        if chat_timezone_settings.empty?
            return
        end

        user_timezone_identifier = chat_timezone_settings[@user.username]
        user_timezone = Timezone.new(user_timezone_identifier)
        chat_timezones = chat_timezone_settings.map { |username, tz_identifier| Timezone.new(tz_identifier) }
        time_board = @time_service.create_time_board(time, user_timezone, chat_timezones)
        message = time_board.map { |tz_identifier, time_str| "#{time_str} #{tz_identifier}" }.join("\n")

        @notification_service.send_html_message(@chat, "<pre>#{message}</pre>")
    end
end