Timezone = Data.define(:identifier)

class Timezone
    def initialize(identifier:)
        begin
            TZInfo::Timezone.get(identifier)
        rescue TZInfo::InvalidTimezoneIdentifier
            raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
        end

        super(identifier: identifier)
    end

    def to_s
        identifier
    end
end
