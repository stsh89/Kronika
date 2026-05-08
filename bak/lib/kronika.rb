require_relative 'epoch'

class Kronika
    def get_current_utc_time
        Epoch.utc_now
    end

    def get_current_time_in_timezone!(timezone)
        Epoch.now_in_timezone!(timezone)
    end
end
