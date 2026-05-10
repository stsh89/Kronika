Chat = Data.define(:id, :users)

class Chat
    def get_user(username)
        user = users[username]
        
        raise NotFoundError, "User #{username} not found in chat #{id}" if user.nil?

        user
    end

    def timezones
        users.values.map(&:timezone).uniq
    end
end
