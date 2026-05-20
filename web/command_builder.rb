# frozen_string_literal: true

module Web
  class CommandBuilder
    def initialize(payload:, clients:)
      @payload = payload
      @clients = clients
    end

    def build
      return NilCommand.new if message.nil? || from.nil?
      return save_timezone_command({ location: }) if location

      build_command_from_text
    end

    private

    attr_reader :payload, :clients

    def base_command_attrs
      { chat_id:, chat_type:, user_id:, clients: }
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
      else
        NilCommand.new
      end
    end

    def notification_command
      chat_type == 'private' ? location_sharing_command : help_message_command
    end

    def location_sharing_command
      SendLocationSharingRequestCommand.new(**base_command_attrs)
    end

    def help_message_command
      SendHelpMessageCommand.new(**base_command_attrs)
    end

    def convert_time_command(time_str)
      ConvertTimeCommand.new(**base_command_attrs, time_str:)
    end

    def drop_timezone_command
      DropTimezoneCommand.new(**base_command_attrs)
    end

    def read_timezone_command
      ReadTimezoneCommand.new(**base_command_attrs)
    end

    def save_timezone_command(input)
      SaveTimezoneCommand.new(**base_command_attrs, input:)
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
      message.fetch(:text)
    end
  end
end
