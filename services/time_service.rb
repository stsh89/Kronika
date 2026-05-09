class TimeService
    def create_time_board(moment, chat_timezones)
        time_board = {}

        chat_timezones.values.uniq.each do |chat_timezone|
            time_board[chat_timezone.identifier] = moment.getlocal(chat_timezone)
        end

        time_board
    end
end