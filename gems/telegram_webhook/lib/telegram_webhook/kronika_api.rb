# frozen_string_literal: true

module TelegramWebhook
  KronikaApiAttributes = Data.define(
    :tenant,
    :scope_badge,
    :unit_badge,
    :persistence,
    :geolocation,
    :clock
  )

  class KronikaApi
    def initialize(attrs)
      self.attrs = attrs
    end

    def save_timezone(user_id:)
      identity_badges = identity_badges(user_id)

      Kronika::SaveTimezoneOperation
        .new(repo:, chrono:)
        .execute(tenant_name:, identity_badges:)
    end

    def read_timezone(user_id:)
      identity_badges = identity_badges(user_id)

      Kronika::ReadTimezoneOperation
        .new(repo:)
        .execute(tenant_name:, identity_badges:)
    end

    def drop_timezone(user_id:)
      identity_badges = identity_badges(user_id)

      Kronika::DropTimezoneOperation
        .new(repo:)
        .execute(tenant_name:, identity_badges:)
    end

    def convert_time(user_id:, hour:, minutes:)
      identity_badges = identity_badges(user_id)

      Kronika::ConvertTimeOperation
        .new(repo:, chrono:)
        .execute(tenant_name:, identity_badges:, hour:, minutes:)
    end

    private

    attr_accessor :attrs

    def tenant_name
      attrs.tenant
    end

    def identity_badges(user_id)
      [attrs.scope_badge, attrs.unit_badge, user_id]
    end

    def repo
      @repo ||= Kronika::Repository.new(attrs.persistence)
    end

    def chrono
      @chrono ||=
        Kronika::Chrono.new(
          geolocation: attrs.geolocation,
          clock: attrs.clock
        )
    end
  end
end
