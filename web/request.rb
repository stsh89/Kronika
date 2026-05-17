# frozen_string_literal: true

module Web
  Request = Data.define(
    :path,
    :request_method,
    :payload,
    :headers
  )
end
