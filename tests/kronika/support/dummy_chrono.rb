# frozen_string_literal: true

class DummyChrono
  TIMEZONES =
    {
      'Europe/Kyiv' => '+02:00'
    }.freeze

  LOCATIONS =
    {
      '49.260566026769844,23.83792988948075' => 'Europe/Kyiv'
    }.freeze

  def get_timezone_by_location(location)
    location_key = "#{location.latitude},#{location.longitude}"
    id = LOCATIONS[location_key]

    get_timezone_by_id(id)
  end

  def get_timezone_by_id(id)
    Kronika::Timezone.new(id) if TIMEZONES[id]
  end

  def get_timestamp(hour, min, timezone)
    offset = TIMEZONES[timezone.id]
    now = Time.now(in: offset)
    time = Time.new(now.year, now.month, now.day, hour, min, 0, now.utc_offset)

    Timestamp.new(time:, timezone:)
  end

  private

  def get_timezone_offset(id)
    TIMEZONES[id]
  end
end
