module Kronika
    class StorageService
        def initialize(client)
            @client = client
        end

        def get_chat(chat_id)
            timezones = @client.get_chat_timezones(chat_id)

            users = timezones.each_with_object({}) do |(username, tz_identifier), acc|
                acc[username] = User.new(username: username, timezone: Timezone.new(tz_identifier))
            end

            Chat.new(
                id: chat_id,
                users: users
            )
        end

        def save_chat(chat)
            @client.save_chat_timezones(chat.id, chat.users.transform_values { |user| user.timezone.identifier })
        end
    end
end
