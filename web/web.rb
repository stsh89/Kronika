# frozen_string_literal: true

require 'console'
require 'json'

require_relative '../app/lib'

require_relative '../clients/geo_names'
require_relative '../clients/global_time'
require_relative '../telegram/telegram'
require_relative '../clients/upstash'

require_relative 'config'
require_relative 'request'
require_relative 'webhook_controller'
require_relative 'server'

module Web
end
