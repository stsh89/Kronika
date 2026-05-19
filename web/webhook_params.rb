# frozen_string_literal: true

module Web
  WebhookParams = Data.define(:message)

  # See https://core.telegram.org/bots/api#message for details
  class WebhookParams
    def message_type
      location = message.fetch(:location, nil)
      return { location: } if location

      text = message.fetch(:text, nil)
      return { text: } if text

      {}
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
