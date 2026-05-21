# frozen_string_literal: true

require_relative 'access_key'
require_relative 'timestamp'

module Kronika
  Tenant = Data.define(:name)
  Location = Data.define(:latitude, :longitude)
  Timezone = Data.define(:id)
end
