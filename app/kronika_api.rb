# frozen_string_literal: true

class KronikaApi
  TENANT_NAME = 'kronika'
  SCOPE_BADGE = 'telegram'
  USER_BADGE = 'user'

  def initialize(persistence:, geolocation:, clock:)
    self.persistence = persistence
    self.geolocation = geolocation
    self.clock = clock
    self.tenant_name = TENANT_NAME
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

  attr_accessor :persistence, :geolocation, :clock, :tenant_name

  def user_identity_badges(user_id)
    [SCOPE_BADGE, USER_BADGE, user_id]
  end

  def repo
    @repo ||= Kronika::Repository.new(persistence)
  end

  def chrono
    @chrono ||= Kronika::Chrono.new(geolocation:, clock:)
  end
end
