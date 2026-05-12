# frozen_string_literal: true

class WebhookController
  def initialize(attributes)
    @secret_token = attributes[:secret_token]
    @telegram_client = attributes[:telegram_client]
    @upstash_client = attributes[:upstash_client]
  end

  def execute(message, headers)
    verify_request_authenticity!(headers)

    chat_id = message.dig('message', 'chat', 'id')
    text = message.dig('message', 'text')
    username = message.dig('message', 'from', 'username')

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

  private

  def verify_request_authenticity(headers)
    got = headers['HTTP_X_TELEGRAM_BOT_API_SECRET_TOKEN']
    want = @secret_token

    raise 'Missing Telegram webhook secret token' if got == '' || got.nil?
    raise 'Invalid Telegram webhook secret token' if got != want
  end
end
