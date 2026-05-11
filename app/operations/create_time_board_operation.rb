# frozen_string_literal: true

module Kronika
  class CreateTimeBoardOperation
    def initialize(chat_id, username, services)
      @chat_id = chat_id
      @username = username
      @storage_service = services[:storage]
      @notification_service = services[:notification]
    end

    def execute(time_str)
      chat = @storage_service.get_chat(@chat_id)

      return if chat.users.empty?

      begin
        user = chat.get_user(@username)
        moment = Moment.from_string(time_str, user.timezone)
        moments = chat.timezones.map { |tz| moment.getlocal(tz) }
        message = moments.map(&:label).join("\n")

        @notification_service.send_html_message(chat, "<pre>#{message}</pre>")
      rescue InvalidArgumentError
      rescue NotFoundError
      end
    end
  end
end
