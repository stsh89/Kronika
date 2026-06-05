# frozen_string_literal: true

require_relative 'kronika_test_helper'

class SaveTimezoneOperationTest < Minitest::Test
  attr_accessor :operation, :repo, :chrono

  def setup
    self.repo = InMemoryRepo.new
    self.chrono = DummyChrono.new
    self.operation = Kronika::SaveTimezoneOperation.new(repo:, chrono:)
  end

  def identity_badges(id = 1)
    ['default', 'user', id]
  end

  def tenant_name
    'tenant1'
  end

  def test_valid_timezone_id
    timezone = operation.execute(
      tenant_name:,
      identity_badges:,
      timezone_id: 'Europe/Kyiv'
    )

    assert_instance_of Kronika::Timezone, timezone
    assert_equal 1, repo.size
  end

  def test_valid_location
    timezone = operation.execute(
      tenant_name:,
      identity_badges:,
      location: {
        latitude: 49.260566026769844,
        longitude: 23.83792988948075
      }
    )

    assert_equal 'Europe/Kyiv', timezone.id
    assert_equal 1, repo.size
  end

  def test_invalid_timezone_id
    timezone = operation.execute(
      tenant_name:,
      identity_badges:,
      timezone_id: 'Europe/Dnipro'
    )

    assert_nil timezone
  end

  def test_invalid_location
    timezone = operation.execute(
      tenant_name:,
      identity_badges:,
      location: {
        latitude: 0.260566026769844,
        longitude: 0.83792988948075
      }
    )

    assert_nil timezone
  end
end
