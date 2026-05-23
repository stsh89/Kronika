# frozen_string_literal: true

require 'json'

require_relative '../app/lib'
require_relative '../clients/geo_names'
require_relative '../clients/sys_time'
require_relative '../clients/upstash'
require_relative '../telegram/telegram'

require_relative 'config'
require_relative 'kronika_container'
require_relative 'request'
require_relative 'webhook_controller'

module Web
end
