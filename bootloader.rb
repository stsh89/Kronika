require_relative 'app/lib'

require_relative 'clients/telegram_api'
require_relative 'clients/upstash'

class Bootloader
    class << self
        def load!
            $stdout.sync = true
            
            validate_environment_variable!('TELEGRAM_BOT_TOKEN')
            validate_environment_variable!('TELEGRAM_WEBHOOK_SECRET_TOKEN')
            validate_environment_variable!('UPSTASH_URL')
            validate_environment_variable!('UPSTASH_TOKEN')

            {
                upstash: Upstash.new,
                telegram: TelegramAPI.new,
            }
        end
    end
end

class MissingEnvironmentVariableError < StandardError; end
class EmptyEnvironmentVariableError < StandardError; end

def validate_environment_variable!(name)
    if ENV[name].nil?
        raise MissingEnvironmentVariableError, "Error: #{name} environment variable must be set"
    end

    if ENV[name] == ''
        raise EmptyEnvironmentVariableError, "Error: #{name} environment variable cannot be empty"
    end
end

