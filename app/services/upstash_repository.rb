# frozen_string_literal: true

require 'kronika'
require 'upstash'

class UpstashRepository
  def initialize
    base_url = APP_ENV['UPSTASH_URL']
    token = APP_ENV['UPSTASH_TOKEN']

    self.client = Upstash::Redis::Api.new(base_url:, token:)
  end

  def get_timezone(access_key)
    id = client.get_key(access_key.to_s)
    Kronika::Timezone.new(id:) if id
  end

  def save_timezone(access_key:, timezone:)
    client.set_key(access_key.to_s, timezone.id)
  end

  def delete_timezone(access_key)
    client.delete_key(access_key.to_s)
  end

  private

  attr_accessor :client
end
