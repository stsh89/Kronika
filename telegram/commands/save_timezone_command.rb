# frozen_string_literal: true

module Telegram
  class SaveTimezoneCommand < Command
    def initialize(attributes:, input:)
      @input = input

      super(attributes)
    end

    def execute
      user = container.save_timezone.execute(user_id:, input:)

      if user
        send_text("Your time zone has been set to #{user.timezone.id}.")
        return
      end

      case input
      in { timezone_id: }
        send_text("Invalid time zone identifier: #{timezone_id}. Please provide a valid time zone.")
      in { location: }
        send_text('Could not find time zone based on your location.')
      end
    end

    private

    attr_reader :input
  end
end
