class TimeService
    def create_time_board(time, user_timezone, chat_timezones)
        timezone = TZInfo::Timezone.get(user_timezone.identifier)
        user_time = timezone.local_time(time.year, time.month, time.day, time.hour, time.min)

        time_board = {}

        chat_timezones.uniq.each do |chat_timezone|
            tz = TZInfo::Timezone.get(chat_timezone.identifier)
            local_time = user_time.getlocal(tz)

            time_board[chat_timezone.identifier] = local_time.strftime("%H:%M")
        end

        time_board
    end
end