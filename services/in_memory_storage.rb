require 'monitor'

class InMemoryStorage
  include MonitorMixin

  def initialize
    @data = {}
    super()
  end

  def [](key)
    synchronize { @data[key.to_s] }
  end

  def []=(key, value)
    synchronize { @data[key.to_s] = value.to_s }
  end
end