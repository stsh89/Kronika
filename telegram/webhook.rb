module Telegram
    class Webhook
        def initialize(message, headers, services)
            @message = message
            @upstash = services[:upstash]
            @kronika = Kronika.new
            @telegram_api = Telegram::API.new(ENV['TELEGRAM_BOT_TOKEN'])

            if headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN'] != ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']
                raise WebhookUnauthorizedError, 'Invalid Telegram webhook secret token'
            end
        end

        def process
            chat_id = @message['message']['chat']['id']
            text = @message['message']['text']
            username = @message['message']['from']['username']

            case text
            when '/utc'
                time = @kronika.get_current_utc_time.to_s

                @telegram_api.send_message(chat_id, time)
            when '/now'
                settings = @upstash.get_hash(chat_id.to_s)
                timezone = settings[username] || 'UTC'
                time = @kronika.get_current_time_in_timezone!(timezone).to_s

                @telegram_api.send_message(chat_id, time)
            when '/my_timezone'
                settings = @upstash.get_hash(chat_id.to_s)
                timezone = settings[username]

                if timezone
                    @telegram_api.send_message(chat_id, "Your timezone is set to #{timezone}")
                else
                    @telegram_api.send_message(chat_id, "You haven't set a timezone yet. Use /set_timezone <your_timezone> to set it.")
                end
            when '/set_timezone'
                settings = @upstash.get_hash(chat_id.to_s)
                settings["#{username}_setting"] = 'awaiting_timezone'
                @upstash.set_hash(chat_id.to_s, settings)
                
                @telegram_api.send_message(chat_id, "Enter your timezone (e.g., 'London'):")
            when '/remove_timezone'
                settings = @upstash.get_hash(chat_id.to_s)
                settings.delete(username)
                @upstash.set_hash(chat_id.to_s, settings)

                @telegram_api.send_message(chat_id, "Your timezone has been removed. You can set it again with /set_timezone <your_timezone>")
            else
                settings = @upstash.get_hash(chat_id.to_s)

                if settings["#{username}_setting"] == 'awaiting_timezone'
                    timezone = text.strip

                    begin
                        @kronika.get_current_time_in_timezone!(timezone)
                    rescue InvalidTimezoneError
                        @telegram_api.send_message(chat_id, "Invalid timezone: #{timezone}. Please enter a valid timezone (e.g., 'London'):")
                        return
                    end

                    settings[username] = timezone
                    settings.delete("#{username}_setting")
                    @upstash.set_hash(chat_id.to_s, settings)

                    @telegram_api.send_message(chat_id, "Your timezone has been set to #{timezone}")
                end
            end
        end
    end
end
