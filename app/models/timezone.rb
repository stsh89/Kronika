# frozen_string_literal: true

module Kronika
  Timezone = Data.define(:identifier)

  class Timezone
    alias id identifier
  end
end
