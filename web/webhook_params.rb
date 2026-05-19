# frozen_string_literal: true

module Web
  WebhookParams = Data.define(:message)

  # See https://core.telegram.org/bots/api#message for details
  class WebhookParams
    def message_type
      location = message.fetch(:location, nil)
      return { cmd: { location: } } if location

      parse_text_command
    end

    def parse_text_command
      text = message.fetch(:text, nil)
      return {} if text.nil?

      case text
      when %r{^/set(?:@KronikaFembot)? (.+)}
        { cmd: { tz_identifier: ::Regexp.last_match(1) } }
      when '/set', '/set@KronikaFembot'
        { cmd: :help_set }
      when '/get', '/get@KronikaFembot'
        { cmd: :get }
      when '/unset', '/unset@KronikaFembot'
        { cmd: :unset }
      when /(\d{1,2}:\d{2})/
        { cmd: { time_str: ::Regexp.last_match(1) } }
      end
    end

    def deconstruct_keys(keys)
      if keys.nil?
        { chat_id: chat_id, chat_type: chat_type, user_id: user_id }
      else
        acc = {}

        acc[:chat_id] = chat_id if keys.include?(:chat_id)
        acc[:chat_type] = chat_type if keys.include?(:chat_type)
        acc[:user_id] = user_id if keys.include?(:user_id)

        acc
      end
    end

    private

    def chat
      message.fetch(:chat)
    end

    def from
      message.fetch(:from)
    end

    def chat_id
      chat.fetch(:id)
    end

    def chat_type
      chat.fetch(:type)
    end

    def user_id
      from.fetch(:id)
    end
  end
end
