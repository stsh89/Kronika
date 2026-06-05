# frozen_string_literal: true

class InMemoryRepo
  def initialize
    self.storage = {}
  end

  def get_timezone(access_key)
    storage[access_key.to_s]
  end

  def save_timezone(access_key:, timezone:)
    storage[access_key.to_s] = timezone
  end

  def delete_timezone(access_key)
    storage.delete(access_key.to_s)
  end

  def size
    storage.size
  end

  private

  attr_accessor :storage
end
