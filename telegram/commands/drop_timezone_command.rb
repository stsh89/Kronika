# frozen_string_literal: true

module Telegram
  class DropTimezoneCommand < Command
    def execute
      container.drop_timezone.execute(tenant_name:, identity_badges:)
      send_text('Your time zone has been removed.')
    end
  end
end
