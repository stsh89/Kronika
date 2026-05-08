require 'time'

class WebhookController
    def initialize(message, headers, services)
        @message = message
        @services = services

        if headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN'] != ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']
            raise 'Invalid Telegram webhook secret token'
        end
    end

    def execute
        chat_id = @message.dig('message', 'chat', 'id')
        text = @message.dig('message', 'text')
        username = @message.dig('message', 'from', 'username')

        return if chat_id.nil? || text.nil? || username.nil?

        case text
        when '/unset'
            RemoveTimezoneOperation.new(chat_id, username, @services).execute
        when /^\/set (.+)/
            tz_identifier = $1.strip
            SetTimezoneOperation.new(chat_id, username, @services).execute(tz_identifier)
        when '/get'
            GetTimezoneOperation.new(chat_id, username, @services).execute
        else
            if text =~ /(\d{1,2}:\d{2})/
                time = Time.parse($1)
                CreateTimeBoardOperation.new(chat_id, username, @services).execute(time)
            end
        end
    end
end