require_relative 'app_loader'
require_relative 'lib/kronika'
require_relative 'telegram/telegram'

services =
    begin
        AppLoader.load!
    rescue StandardError => e
        puts e.message
        puts e.full_message

        exit(1)
    end

run do |env|
    request = Rack::Request.new(env)

    case request.path
    when "/webhook"
        case request.request_method
        when "POST"
            begin
                message = JSON.parse(request.body.read)
                headers = request.env.select { |k, v| k.start_with?('HTTP_') }

                Telegram::Webhook.new(message, headers, services).process
            rescue  StandardError => e
                puts e.message
                puts e.full_message
            end
        end
    end

    [200, {}, []]
end
