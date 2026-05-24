# frozen_string_literal: true

module Telegram
  class SendLocationSharingRequestCommand < Command
    def execute
      bot_api.send_message(
        chat_id,
        'Please share your location. I will try to determine your time zone.',
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
  end
end
