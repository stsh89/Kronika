# frozen_string_literal: true

module Telegram
  CommandAttributes = Data.define(:chat_id, :chat_type, :user_id, :bot_api, :container)

  class Command
    class << self
      def from_payload(payload:, bot_api:, container:)
        CommandBuilder.new(payload:, bot_api:, container:).build
      end
    end

    def initialize(attributes)
      @attributes = attributes
      @tenant_name = TENANT_NAME
    end

    private

    attr_reader :attributes, :tenant_name

    def identity_badges
      [SCOPE_BADGE, UNIT_BADGE, user_id]
    end

    def chat_type
      attributes.chat_type
    end

    def bot_api
      attributes.bot_api
    end

    def user_id
      attributes.user_id
    end

    def container
      attributes.container
    end

    def chat_id
      attributes.chat_id
    end

    def send_text(text)
      bot_api.send_message(chat_id, text)
    end

    def send_html(html)
      bot_api.send_message(chat_id, html, { parse_mode: 'HTML' })
    end
  end
end
