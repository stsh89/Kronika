# frozen_string_literal: true

module Kronika
  Chat = Data.define(:id, :chat_type)

  class Chat
    CHAT_TYPES = %w[private group supergroup channel].freeze

    def initialize(id:, chat_type:)
      raise InvalidArgumentError, "Chat ID can't be blank." if id.to_s.empty?
      raise InvalidArgumentError, "Chat type can't be blank." if chat_type.to_s.empty?
      raise InvalidArgumentError, "#{chat_type} is not a valid chat type." unless CHAT_TYPES.include?(chat_type)

      super
    end

    def private?
      chat_type == 'private'
    end
  end
end
