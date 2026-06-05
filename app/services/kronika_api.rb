# frozen_string_literal: true

require_relative 'geo_names_chrono'
require_relative 'tzinfo_chrono'
require_relative 'upstash_repository'

require 'kronika'

class KronikaApi
  TENANT_NAME = 'kronika'
  SCOPE_BADGE = 'telegram'
  USER_BADGE = 'user'

  def initialize
    self.tenant_name = TENANT_NAME
    self.repo = UpstashRepository.new
    self.tzinfo_chrono = TZInfoChrono.new
    self.geo_names_chrono = GeoNamesChrono.new
  end

  def save_timezone(user_id:, timezone_id: nil, location: {})
    identity_badges = user_identity_badges(user_id)
    chrono = timezone_id ? tzinfo_chrono : geo_names_chrono

    Kronika::SaveTimezoneOperation
      .new(repo:, chrono:)
      .execute(tenant_name:, identity_badges:, timezone_id:, location:)
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
      .new(repo:, chrono: tzinfo_chrono)
      .execute(tenant_name:, identity_badges:, hour:, minutes:)
  end

  private

  attr_accessor :repo, :tzinfo_chrono, :geo_names_chrono, :tenant_name

  def user_identity_badges(user_id)
    [SCOPE_BADGE, USER_BADGE, user_id]
  end
end
