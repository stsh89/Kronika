# frozen_string_literal: true

module Kronika
  autoload :AccessKey, 'kronika/access_key'
  autoload :Location, 'kronika/location'
  autoload :Tenant, 'kronika/tenant'
  autoload :Timestamp, 'kronika/timestamp'
  autoload :Timezone, 'kronika/timezone'

  autoload :ConvertTimeOperation, 'kronika/convert_time_operation'
  autoload :ReadTimezoneOperation, 'kronika/read_timezone_operation'
  autoload :DropTimezoneOperation, 'kronika/drop_timezone_operation'
  autoload :SaveTimezoneOperation, 'kronika/save_timezone_operation'
end
