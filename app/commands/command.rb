# frozen_string_literal: true

require 'forwardable'

class Command
  Attrs = Data.define(
    :chat_id,
    :chat_type,
    :user_id,
    :bot_api,
    :kronika_api
  )

  class << self
    def from_payload(payload:, bot_api:, kronika_api:)
      CommandBuilder.new(payload:, bot_api:, kronika_api:).build
    end
  end

  extend Forwardable

  def initialize(attrs)
    self.attrs = attrs
  end

  private

  attr_accessor :attrs

  def_delegators :attrs, :chat_id, :chat_type, :bot_api, :user_id, :kronika_api

  def send_text(text)
    bot_api.send_message(chat_id, text)
  end

  def send_html(html)
    bot_api.send_message(chat_id, html, { parse_mode: 'HTML' })
  end
end
