# frozen_string_literal: true

require_relative 'kronika/access_key'
require_relative 'kronika/location'
require_relative 'kronika/tenant'
require_relative 'kronika/timestamp'
require_relative 'kronika/timezone'

module Kronika
  autoload :Chrono, 'kronika/chrono'
  autoload :Repository, 'kronika/repository'

  autoload :ConvertTimeOperation, 'kronika/convert_time_operation'
  autoload :ReadTimezoneOperation, 'kronika/read_timezone_operation'
  autoload :DropTimezoneOperation, 'kronika/drop_timezone_operation'
  autoload :SaveTimezoneOperation, 'kronika/save_timezone_operation'
end
