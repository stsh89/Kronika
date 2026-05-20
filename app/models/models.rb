# frozen_string_literal: true

module Kronika
  Location = Data.define(:latitude, :longitude)
  Timezone = Data.define(:id)
  User = Data.define(:id, :timezone)
end
