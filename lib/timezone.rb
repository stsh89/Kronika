class Timezone
    def initialize(identifier)
        begin
            @tz = TZInfo::Timezone.get(identifier)
        rescue TZInfo::InvalidTimezoneIdentifier
            raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
        end
    end

    def identifier
        @tz.identifier
    end

    def now
        @tz.now
    end
end
