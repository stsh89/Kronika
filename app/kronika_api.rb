# frozen_string_literal: true

require 'kronika'
require 'tzinfo'

class KronikaApi
  TENANT_NAME = 'kronika'
  SCOPE_BADGE = 'telegram'
  USER_BADGE = 'user'

  def initialize(persistence:, geolocation:)
    clock = Clock.new

    self.tenant_name = TENANT_NAME
    self.repo = Kronika::Repository.new(persistence)
    self.chrono = Kronika::Chrono.new(geolocation:, clock:)
  end

  def save_timezone(user_id:, input:)
    identity_badges = user_identity_badges(user_id)

    Kronika::SaveTimezoneOperation
      .new(repo:, chrono:)
      .execute(tenant_name:, identity_badges:, input:)
  end

  def read_timezone(user_id:)
    identity_badges = user_identity_badges(user_id)

    Kronika::ReadTimezoneOperation
      .new(repo:)
      .execute(tenant_name:, identity_badges:)
  end

  def drop_timezone(user_id:)
    identity_badges = user_identity_badges(user_id)

    Kronika::DropTimezoneOperation
      .new(repo:)
      .execute(tenant_name:, identity_badges:)
  end

  def convert_time(user_id:, hour:, minutes:)
    identity_badges = user_identity_badges(user_id)

    Kronika::ConvertTimeOperation
      .new(repo:, chrono:)
      .execute(tenant_name:, identity_badges:, hour:, minutes:)
  end

  private

  attr_accessor :repo, :chrono, :tenant_name

  def user_identity_badges(user_id)
    [SCOPE_BADGE, USER_BADGE, user_id]
  end

  class Clock
    def initialize
      self.client = TZInfo::Timezone
    end

    def time_now(timezone_id)
      tz = get_timezone(timezone_id)

      return unless tz

      tz.now
    end

    private

    attr_accessor :client

    def get_timezone(timezone_id)
      client.get(timezone_id)
    rescue TZInfo::InvalidTimezoneIdentifier
      nil
    end
  end
end
