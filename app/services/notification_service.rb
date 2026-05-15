# frozen_string_literal: true

module Kronika
  class NotificationService
    def initialize(client)
      @client = client
    end

    def send_location_sharing_request(chat, message)
      @client.send_message(
        chat.id,
        message,
        reply_markup: {
          keyboard: [[
            {
              text: '📍 Share My Location',
              request_location: true
            }
          ]],
          resize_keyboard: true,
          one_time_keyboard: true
        }
      )
    end

    def send_message(chat, message)
      @client.send_message(chat.id, message)
    end

    def send_html_message(chat, html)
      @client.send_message(chat.id, html, { parse_mode: 'HTML' })
    end
  end
end
