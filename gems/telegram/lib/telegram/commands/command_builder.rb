# frozen_string_literal: true

module Telegram
  class CommandBuilder
    def initialize(payload:, bot_api:, kronika_api:)
      @payload = payload
      @bot_api = bot_api
      @kronika_api = kronika_api
    end

    def build
      return if message.nil? || from.nil?
      return save_timezone_command({ location: }) if location

      build_command_from_text
    end

    private

    attr_reader :payload, :bot_api, :kronika_api

    def command_attributes
      CommandAttributes.new(chat_id:, chat_type:, user_id:, bot_api:, kronika_api:)
    end

    def build_command_from_text
      case text
      when %r{^/set(?:@KronikaFembot)? (.+)}
        save_timezone_command({ timezone_id: ::Regexp.last_match(1) })
      when '/set', '/set@KronikaFembot'
        notification_command
      when '/get', '/get@KronikaFembot'
        read_timezone_command
      when '/unset', '/unset@KronikaFembot'
        drop_timezone_command
      when /(\d{1,2}:\d{2})/
        convert_time_command(::Regexp.last_match(1))
      end
    end

    def notification_command
      chat_type == 'private' ? location_sharing_command : help_message_command
    end

    def location_sharing_command
      SendLocationSharingRequestCommand.new(command_attributes)
    end

    def help_message_command
      SendHelpMessageCommand.new(command_attributes)
    end

    def convert_time_command(time_str)
      ConvertTimeCommand.new(attributes: command_attributes, time_str:)
    end

    def drop_timezone_command
      DropTimezoneCommand.new(command_attributes)
    end

    def read_timezone_command
      ReadTimezoneCommand.new(command_attributes)
    end

    def save_timezone_command(input)
      SaveTimezoneCommand.new(attributes: command_attributes, input:)
    end

    def user_id
      from.fetch(:id)
    end

    def chat
      message.fetch(:chat)
    end

    def chat_id
      chat.fetch(:id)
    end

    def chat_type
      chat.fetch(:type)
    end

    def location
      message.fetch(:location, nil)
    end

    def message
      payload.fetch(:message, nil)
    end

    def from
      message.fetch(:from, nil)
    end

    def text
      message.fetch(:text, nil)
    end
  end
end
