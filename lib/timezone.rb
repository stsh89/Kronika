class Timezone
    attr_accessor :abbr
    attr_reader :identifier

    def initialize(identifier)
        begin
            tz = TZInfo::Timezone.get(identifier)

            @identifier = identifier
            @abbr = tz.current_period.abbr
        rescue TZInfo::InvalidTimezoneIdentifier
            raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
        end
    end
end
