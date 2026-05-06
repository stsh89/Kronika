def validate_environment_variable(name)
    if ENV[name].nil?
        puts "Error: #{name} environment variable must be set"
        exit(1)
    end

    if ENV[name] == ''
        puts "Error: #{name} environment variable cannot be empty"
        exit(1)
    end
end

validate_environment_variable('TELEGRAM_BOT_TOKEN')
validate_environment_variable('TELEGRAM_WEBHOOK_SECRET_TOKEN')

require_relative 'lib/kronika'
require_relative 'telegram/telegram'

run do |env|
    request = Rack::Request.new(env)

    if request.post? && request.path == "/webhook"
        process_request(request)
    end

    [200, {}, []]
end

def process_request(request)
    return if request.body.nil?

    begin
        message = JSON.parse(request.body.read)
        headers = request.env.select { |k, v| k.start_with?('HTTP_') }

        Telegram::Webhook.new(message, headers).process
    rescue Telegram::WebhookUnauthorizedError => e
        puts "Unauthorized webhook request: #{e.message}"
        puts e.backtrace
    rescue Telegram::WebhookInvalidArgumentError => e
        puts "Invalid argument in webhook request: #{e.message}"
        puts e.backtrace
    rescue JSON::ParserError => e
        puts "Failed to parse JSON in webhook request: #{e.message}"
        puts e.backtrace
    rescue StandardError => e
        puts "Error processing webhook request: #{e.message}"
        puts e.backtrace
    end
end
