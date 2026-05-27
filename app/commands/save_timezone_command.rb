# frozen_string_literal: true

class SaveTimezoneCommand < Command
  def initialize(attrs:, input:)
    self.input = input

    super(attrs)
  end

  def execute
    timezone = kronika_api.save_timezone(user_id:, input:)
    timezone ? confirm(timezone) : reject
  end

  private

  attr_accessor :input

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
