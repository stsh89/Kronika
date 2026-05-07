class AppLoader
    class << self
        def load!
            validate_environment_variable('TELEGRAM_BOT_TOKEN')
            validate_environment_variable('TELEGRAM_WEBHOOK_SECRET_TOKEN')

            {storage: InMemoryStorage.new}
        end
    end
end

class MissingEnvironmentVariableError < StandardError; end
class EmptyEnvironmentVariableError < StandardError; end

def validate_environment_variable(name)
    if ENV[name].nil?
        raise MissingEnvironmentVariableError, "Error: #{name} environment variable must be set"
    end

    if ENV[name] == ''
        raise EmptyEnvironmentVariableError, "Error: #{name} environment variable cannot be empty"
    end
end

