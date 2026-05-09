class TimeService
    def create_time_board(time, chat_timezones)
        time_board = {}

        chat_timezones.values.uniq.each do |chat_timezone|
            tz = TZInfo::Timezone.get(chat_timezone.identifier)
            local_time = time.getlocal(tz)

            time_board[chat_timezone.identifier] = local_time.strftime("%H:%M")
        end

        time_board
    end
end