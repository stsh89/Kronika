# frozen_string_literal: true

module Telegram
  class Command
    class << self
      def from_payload(payload:, clients:)
        CommandBuilder.new(payload:, clients:).build
      end
    end

    def initialize(chat_id:, chat_type:, user_id:, clients:)
      @chat_id = chat_id
      @chat_type = chat_type
      @user_id = user_id
      @clients = clients
    end

    private

    attr_reader :chat_id, :chat_type, :user_id, :clients

    def send_text(text)
      telegram.send_message(chat_id, text)
    end

    def send_html(html)
      telegram.send_message(chat_id, html, { parse_mode: 'HTML' })
    end

    def global_time
      clients.fetch(:global_time)
    end

    def telegram
      clients.fetch(:telegram)
    end

    def geo_names
      clients.fetch(:geo_names)
    end

    def upstash
      clients.fetch(:upstash)
    end
  end
end
