# frozen_string_literal: true

module Web
  WebhookParams = Data.define(:chat_id, :chat_type, :user_id, :message)

  class WebhookParams
    class << self
      def from_payload!(payload)
        new(
          chat_id: get_value!(payload, %i[message chat id]),
          chat_type: get_value!(payload, %i[message chat type]),
          user_id: get_value!(payload, %i[message from id]),
          message: get_value!(payload, %i[message])
        )
      end

      private

      def get_value!(payload, path)
        value = payload.dig(*path)

        if value.nil? || value == ''
          raise "Invalid webhook payload. Missing #{path.join('.')} value. Payload: #{payload}"
        end

        value
      end
    end
  end
end
