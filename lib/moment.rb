class Moment
    def initialize(time)
        @time = time
    end

    def getlocal(timezone)
        tz = TZInfo::Timezone.get(timezone.identifier)

        Moment.new(tz.getlocal(@time))
    end

    def label
        @time.strftime("%H:%M")
    end

    class << self
        def from_string(time_str, timezone)
            parsed = Time.strptime(time_str, "%H:%M")
            tz = TZInfo::Timezone.get(timezone.identifier)
            now = tz.now
            time = tz.local_time(now.year, now.month, now.day, parsed.hour, parsed.min)

            new(time)
        end
    end
end
