class CreateTimeBoardOperation
    def initialize(chat_id, username, services)
        @chat = Chat.new(chat_id)
        @user = User.new(username)
        @storage_service = services[:storage]
        @notification_service = services[:notification]
    end

    def execute(time_str)
        chat_timezones = @storage_service.get_chat_timezones(@chat)

        return if chat_timezones.empty?

        user_timezone = chat_timezones[@user.username]

        return if user_timezone.nil?

        moment = Moment.from_string(time_str, user_timezone)

        moments = chat_timezones.values.uniq.map do |chat_timezone|
            moment.getlocal(chat_timezone)
        end

        message = moments.map { |m| "#{m.label} #{m.timezone.identifier}" }.join("\n")

        @notification_service.send_html_message(@chat, "<pre>#{message}</pre>")
    end
end