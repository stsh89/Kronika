require 'async'
require 'async/http/internet'

module Telegram
    class API
        def initialize(token)
            @base_url = "https://api.telegram.org/bot#{token}/"
        end

        def send_message(chat_id, text)
            invoke_web_request('sendMessage', { chat_id: chat_id, text: text })
        end

        private

        def invoke_web_request(method, body)
            url = @base_url + method
            headers = { 'Content-Type': 'application/json' }
            internet = Async::HTTP::Internet.new

            begin
                Async::Task.current.with_timeout(3) do
                    internet.post(url, headers, [body.to_json])
                end
            ensure
                internet.close
            end
        end
    end
end
