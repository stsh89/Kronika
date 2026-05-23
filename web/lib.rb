# frozen_string_literal: true

require 'json'

require_relative '../clients/geo_names'
require_relative '../clients/sys_time'
require_relative '../clients/upstash'

require_relative '../api/lib'
require_relative '../telegram/lib'

require_relative 'config'
require_relative 'kronika_api'
require_relative 'request'
require_relative 'webhook_controller'
