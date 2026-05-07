module Telegram
    class Webhook
        def initialize(message, headers, services)
            @message = message
            @storage = services[:storage]
            @kronika = Kronika.new
            @telegram_api = Telegram::API.new(ENV['TELEGRAM_BOT_TOKEN'])

            if headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN'] != ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']
                raise WebhookUnauthorizedError, 'Invalid Telegram webhook secret token'
            end
        end

        def process
            chat_id = @message['message']['chat']['id']
            text = @message['message']['text']

            case text
            when '/utc'
                @telegram_api.send_message(chat_id, @kronika.get_current_time.to_s)
            end
        end
    end
end
