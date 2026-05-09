class Moment
    def initialize(time, timezone)
        @time = time
        @timezone = timezone
    end

    def getlocal(timezone)
        tz = TZInfo::Timezone.get(timezone.identifier)

        Moment.new(@time.getlocal(tz), timezone)
    end

    def label
        "#{@time.strftime("%H:%M")} #{@timezone.identifier}"
    end

    class << self
        def from_string(time_str, timezone)
            parsed = Time.strptime(time_str, "%H:%M")
            tz = TZInfo::Timezone.get(timezone.identifier)
            now = tz.now
            time = tz.local_time(now.year, now.month, now.day, parsed.hour, parsed.min)

            new(time, timezone)
        end
    end
end
