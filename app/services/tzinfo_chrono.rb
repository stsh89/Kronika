# frozen_string_literal: true

require 'kronika'
require 'tzinfo'

class TZInfoChrono
  def get_timezone_by_id(id)
    return unless validate_timezone_id(id)

    Kronika::Timezone.new(id:)
  end

  def get_timestamp(hour, min, timezone)
    tz = TZInfo::Timezone.get(timezone.id)
    now = tz.now
    time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)

    Kronika::Timestamp.new(time:, timezone:)
  end

  private

  def validate_timezone_id(timezone_id)
    TZInfo::Timezone.get(timezone_id)
  rescue TZInfo::InvalidTimezoneIdentifier
    nil
  end
end
