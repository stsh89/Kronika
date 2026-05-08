require 'async/http/internet'
require 'tzinfo'

require_relative 'impls/telegram_api'
require_relative 'impls/upstash'

require_relative 'services/notification_service'
require_relative 'services/storage_service'
require_relative 'services/time_service'

require_relative 'app_loader'
require_relative 'lib'
require_relative 'webhook_controller'

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

                WebHookController.new(message, headers, services).execute
            rescue  StandardError => e
                puts e.message
                puts e.full_message
            end
        end
    end

    [200, {}, []]
end
