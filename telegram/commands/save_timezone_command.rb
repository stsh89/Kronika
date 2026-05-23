# frozen_string_literal: true

module Telegram
  class SaveTimezoneCommand < Command
    def initialize(attributes:, input:)
      @input = input

      super(attributes)
    end

    def execute
      timezone = kronika_api.save_timezone.execute(tenant_name:, identity_badges:, input:)
      timezone ? confirm(timezone) : reject
    end

    private

    attr_reader :input

    def confirm(timezone)
      send_text("Your time zone has been set to #{timezone.id}.")
    end

    def reject
      case input
      in { timezone_id: }
        send_text("Invalid time zone identifier: #{timezone_id}. Please provide a valid time zone.")
      in { location: }
        send_text('Could not find time zone based on your location.')
      end
    end
  end
end
