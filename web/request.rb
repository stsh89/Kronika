# frozen_string_literal: true

module Web
  Request = Data.define(:path, :verb, :body, :headers)

  class Request
    def payload
      JSON.parse(body, symbolize_names: true)
    end

    def webhook?
      path == '/webhook' && verb == 'POST'
    end
  end
end
