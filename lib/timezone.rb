class Timezone
    attr_reader :identifier

    def initialize(identifier)
        validate_identifier(identifier)

        @identifier = identifier
    end

    private

    def validate_identifier(identifier)
        begin
            TZInfo::Timezone.get(identifier)
        rescue TZInfo::InvalidTimezoneIdentifier
            raise InvalidArgumentError, "Invalid timezone identifier: #{identifier}"
        end
    end
end
