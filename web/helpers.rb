# frozen_string_literal: true

module Web
  module Helpers
    module_function

    def try_parse_time(time_str)
      Time.strptime(time_str, '%H:%M')
    rescue ArgumentError
      nil
    end
  end
end
