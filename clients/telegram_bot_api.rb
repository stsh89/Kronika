# frozen_string_literal: true

require 'async'
require 'async/http/internet'

class TelegramBotAPI
  def initialize(token)
    @base_url = "https://api.telegram.org/bot#{token}/"
  end

  def send_message(chat_id, text, options = {})
    url = "#{@base_url}sendMessage"
    body = { chat_id: chat_id, text: text }.merge(options)
    internet = Async::HTTP::Internet.new

    begin
      Async::Task.current.with_timeout(3) do
        internet.post(url, { 'Content-Type': 'application/json' }, [body.to_json])
      end
    ensure
      internet.close
    end
  end
end
