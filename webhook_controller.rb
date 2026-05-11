# frozen_string_literal: true

class WebhookController
  def initialize(message, headers, clients)
    @message = message
    @telegram_client = clients[:telegram]
    @upstash_client = clients[:upstash]

    return unless headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN'] != ENV['TELEGRAM_WEBHOOK_SECRET_TOKEN']

    raise 'Invalid Telegram webhook secret token'
  end

  def execute
    chat_id = @message.dig('message', 'chat', 'id')
    text = @message.dig('message', 'text')
    username = @message.dig('message', 'from', 'username')

    return if chat_id.nil? || text.nil? || username.nil?

    case text
    when '/unset'
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::RemoveTimezoneOperation.new(chat_id, username, services).execute
    when '/set'
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::SetTimezoneOperation.new(chat_id, username, services).execute('')
    when %r{^/set (.+)}
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::SetTimezoneOperation
        .new(chat_id, username, services)
        .execute(::Regexp.last_match(1).strip)
    when '/get'
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::GetTimezoneOperation.new(chat_id, username, services).execute
    when /(\d{1,2}:\d{2})/
      services = {
        storage: Kronika::StorageService.new(@upstash_client),
        notification: Kronika::NotificationService.new(@telegram_client)
      }

      Kronika::CreateTimeBoardOperation
        .new(chat_id, username, services)
        .execute(::Regexp.last_match(1))
    end
  end
end
