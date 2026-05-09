class CreateTimeBoardOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @time_service = services[:time]
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute(time_str)
        chat_timezones = @storage_service.get_chat_timezones(@chat)

        return if chat_timezones.empty?

        user_timezone = chat_timezones[@user.username]

        return if user_timezone.nil?

        time = Time.strptime(time_str, "%H:%M")
        now = user_timezone.now
        local_time = user_timezone.local_time(now.year, now.month, now.day, time.hour, time.min)
        time_board = @time_service.create_time_board(local_time, chat_timezones)
        message = time_board.map { |tz_identifier, time_str| "#{time_str} #{tz_identifier}" }.join("\n")

        @notification_service.send_html_message(@chat, "<pre>#{message}</pre>")
    end
end