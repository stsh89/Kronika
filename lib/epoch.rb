class Epoch
    def initialize(time)
        @time = time
    end

    def to_s
        @time.strftime('%H:%M %Z')
    end

    class << self 
        def now
            Epoch.new(Time.now.utc)
        end
    end
end