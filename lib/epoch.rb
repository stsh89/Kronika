require 'tzinfo'

class Epoch
    def initialize(time)
        @time = time
    end

    def to_s
        @time.strftime('%H:%M %Z')
    end

    class << self 
        def utc_now
            time = Time.now.utc
            Epoch.new(time)
        end

        def now_in_timezone!(timezone)
            time = time_by_city!(timezone)
            Epoch.new(time)
        end
    end
end

class InvalidTimezoneError < StandardError; end

def time_by_city!(city_name)
  identifier = TZInfo::Timezone.all_identifiers.find do |id| 
    id.split('/').last.casecmp?(city_name) 
  end

  raise InvalidTimezoneError, "Timezone not found for #{city_name}" unless identifier

  TZInfo::Timezone.get(identifier).now.to_time
end