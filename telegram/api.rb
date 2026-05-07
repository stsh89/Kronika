require 'net/http'

module Telegram
    class API
        def initialize(token)
            @base_url = "https://api.telegram.org/bot#{@token}/"
        end

        def send_message(chat_id, text)
            invoke_web_request('sendMessage', { chat_id: chat_id, text: text })
        end

        private

        def invoke_web_request(method, body)
            uri = URI(@base_url + method)
            headers = { 'Content-Type': 'application/json' }
            response = Net::HTTP.post(uri, body.to_json, headers)

            puts response.body
        end
    end
end
