# frozen_string_literal: true

module Kronika
  Chat = Data.define(:id, :chat_type)

  class Chat
    CHAT_TYPES = %w[private group supergroup channel].freeze

    def initialize(id:, chat_type:)
      raise InvalidArgumentError, 'Missing chat id' if id.nil? || id == ''
      raise InvalidArgumentError, 'Missing chat type' if chat_type.nil? || chat_type == ''
      raise InvalidArgumentError, "Invalid chat type: #{chat_type}" unless CHAT_TYPES.include?(chat_type)

      super
    end

    def private?
      chat_type == 'private'
    end
  end
end
