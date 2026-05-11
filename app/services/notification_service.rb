# frozen_string_literal: true

module Kronika
  class NotificationService
    def initialize(client)
      @client = client
    end

    def send_message(chat, message)
      @client.send_message(chat.id, message)
    end

    def send_html_message(chat, html)
      @client.send_html_message(chat.id, html)
    end
  end
end
