require_relative 'bootloader'
require_relative 'webhook_controller'

clients =
    begin
        Bootloader.load!
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

                WebhookController.new(message, headers, clients).execute
            rescue  StandardError => e
                puts e.message
                puts e.full_message
            end
        end
    end

    [200, {}, []]
end
