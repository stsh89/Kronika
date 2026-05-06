module Telegram
    class Webhook
        def initialize(message, headers)
            @message = message
            @headers = headers
            @kronika = Kronika.new
            @telegram_api = Telegram::API.new(ENV['TELEGRAM_BOT_TOKEN'])

            if @headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN'] != ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']
                raise WebhookUnauthorizedError, 'Invalid Telegram webhook secret token'
            end
        end

        def process
            chat_id = @message['message']['chat']['id']
            text = @message['message']['text']

            case text
            when '/utc'
                response = @kronika.get_current_time
                @telegram_api.send_message(chat_id, response)
            else
                raise Telegram::WebhookInvalidArgumentError, "Invalid Telegram webhook argument provided: '#{text}'"
            end
        end
    end
end