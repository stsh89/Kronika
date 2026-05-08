class Upstash
    REQUEST_TIMEOUT_IN_SECONDS = 3

    def initialize
        @url = ENV['UPSTASH_URL']
        @token = ENV['UPSTASH_TOKEN']
        @headers = { 'authorization': "Bearer #{@token}" }
    end

    def get_chat_timezones(chat_id)
        get_hash("chat:#{chat_id}:timezones")
    end

    def save_chat_timezones(chat_id, timezones)
        set_hash("chat:#{chat_id}:timezones", timezones)
    end

    private

    def get_hash(key)
        url = "#{@url}/get/#{key}"
        internet = Async::HTTP::Internet.new

        begin
            response = Async::Task.current.with_timeout(REQUEST_TIMEOUT_IN_SECONDS) do
                internet.get(url, @headers)
            end

            unless response.success?
                raise "Upstash API error. Status: #{response.status}. Body: #{response.read}" 
            end

            body = response.read
            result = JSON.parse(body)['result']

            return {} if result.nil?

            JSON.parse(result).to_h
        ensure            
            internet.close
        end
    end

    def set_hash(key, value)
        url = "#{@url}/set/#{key}"
        internet = Async::HTTP::Internet.new

        begin
            Async::Task.current.with_timeout(REQUEST_TIMEOUT_IN_SECONDS) do
                internet.post(url, @headers, [value.to_json])
            end
        ensure
            internet.close
        end
    end
end