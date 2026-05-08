class StorageService
    def initialize(impl)
        @impl = impl
    end

    def get_chat_timezones(chat)
        @impl.get_chat_timezones(chat.id)
    end

    def get_user_timezone(chat, user)
        chat_timezones = @impl.get_chat_timezones(chat.id)

        raise NotFoundError, "No timezones found for chat #{chat.id}" if chat_timezones.empty?

        user_timezone = chat_timezones[user.username]

        raise NotFoundError, "No timezone found for user #{user.username} in chat #{chat.id}" if user_timezone.nil?

        user_timezone
    end

    def save_chat_timezones(chat, timezones)
        @impl.save_chat_timezones(chat.id, timezones)
    end
end