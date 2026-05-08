class NotificationService
    def initialize(impl)
        @impl = impl
    end

    def send_message(chat, message)
        @impl.send_message(chat.id, message)
    end

    def send_html_message(chat, html)
        @impl.send_html_message(chat.id, html)
    end
end