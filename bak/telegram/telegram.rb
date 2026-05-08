require_relative 'api'
require_relative 'webhook'

module Telegram
    class WebhookUnauthorizedError < StandardError; end
end