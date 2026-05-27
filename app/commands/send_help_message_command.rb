# frozen_string_literal: true

class SendHelpMessageCommand < Command
  def execute
    send_html(
      'Please provide a time zone identifier (e.g., /set Europe/London). ' \
      'Alternatively, you can use the /set command in our ' \
      '<a href="https://t.me/KronikaFembot">private chat</a>, ' \
      "and I'll try to automatically detect your time zone based on your location."
    )
  end
end
