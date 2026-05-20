# frozen_string_literal: true

require 'console'
require 'time'

require_relative '../app/lib'

require_relative '../clients/geo_names'
require_relative '../clients/global_time'
require_relative '../clients/telegram'
require_relative '../clients/upstash'

require_relative 'config'
require_relative 'request'
require_relative 'command_builder'
require_relative 'command'
require_relative 'webhook_controller'
require_relative 'server'

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
