# frozen_string_literal: true

module TelegramWebhook
  CommandAttributes = Data.define(
    :chat_id,
    :chat_type,
    :user_id,
    :bot_api,
    :kronika_api
  )

  class Command
    class << self
      def from_payload(payload:, bot_api:, kronika_api:)
        CommandBuilder.new(payload:, bot_api:, kronika_api:).build
      end
    end

    def initialize(attrs)
      self.attrs = attrs
    end

    private

    attr_accessor :attrs

    def chat_type
      attrs.chat_type
    end

    def bot_api
      attrs.bot_api
    end

    def user_id
      attrs.user_id
    end

    def kronika_api
      attrs.kronika_api
    end

    def chat_id
      attrs.chat_id
    end

    def send_text(text)
      bot_api.send_message(chat_id, text)
    end

    def send_html(html)
      bot_api.send_message(chat_id, html, { parse_mode: 'HTML' })
    end
  end
end
