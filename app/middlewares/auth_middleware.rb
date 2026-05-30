# frozen_string_literal: true

require 'console'

class AuthMiddleware
  def initialize(app, token)
    self.app = app
    self.token = token
  end

  def call(env)
    request = Rack::Request.new(env)

    if token == request.get_header('HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN')
      app.call(env)
    else
      Console.warn('The authenticity of the webhook request could not be verified.')
      [200, {}, []]
    end
  end

  private

  attr_accessor :app, :token
end
