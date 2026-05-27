# frozen_string_literal: true

require 'falcon/environment/rack'

service 'webhook.localhost' do
  include Falcon::Environment::Rack

  scheme 'http'
  port 3000

  endpoint do
    Async::HTTP::Endpoint.for(scheme, '0.0.0.0', port:)
  end
end
