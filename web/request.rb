# frozen_string_literal: true

module Web
  Request = Data.define(:body, :headers)

  class Request
    def payload
      JSON.parse(body, symbolize_names: true)
    end
  end
end
