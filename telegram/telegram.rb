require_relative 'api'
require_relative 'webhook'

module Telegram
    class WebhookUnauthorizedError < StandardError; end
    class WebhookInvalidArgumentError < StandardError; end
end