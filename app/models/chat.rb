# frozen_string_literal: true

module Kronika
  Chat = Data.define(:id, :chat_type)

  class Chat
    CHAT_TYPES = %w[private group supergroup channel]

    def initialize(id:, chat_type:)
      raise InvalidArgumentError, "Invalid chat type: #{chat_type}" unless CHAT_TYPES.include?(chat_type)

      super
    end

    def is_private?
      chat_type == 'private'
    end
  end
end
