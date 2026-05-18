# frozen_string_literal: true

module Web
  WebhookParams = Data.define(:chat_id, :chat_type, :user_id, :message)

  class WebhookParams
    class << self
      def from_message!(message)
        new(
          chat_id: get_value!(message, %i[chat id]),
          chat_type: get_value!(message, %i[chat type]),
          user_id: get_value!(message, %i[from id]),
          message:
        )
      end

      private

      def get_value!(message, path)
        value = message.dig(*path)

        raise "Unexpected webhook message: missing #{path.join('.')} path. Message: #{message}" if value.to_s.empty?

        value
      end
    end
  end
end
