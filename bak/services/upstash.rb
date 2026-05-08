require 'async'
require 'async/http/internet'

class Upstash
    def initialize
        @url = ENV['UPSTASH_URL']
        @token = ENV['UPSTASH_TOKEN']
    end

    def delete(key)
        url = "#{@url}/del/#{key}"
        headers = { 'Authorization': "Bearer #{@token}" }
        internet = Async::HTTP::Internet.new
        
        begin
            Async::Task.current.with_timeout(3) do
                internet.get(url, headers)
            end
        ensure
            internet.close
        end
    end

    def set_hash(key, value)
        url = "#{@url}/set/#{key}"
        headers = { 'Authorization': "Bearer #{@token}" }
        internet = Async::HTTP::Internet.new

        begin
            Async::Task.current.with_timeout(3) do
                internet.post(url, headers, [value.to_json])
            end
        ensure
            internet.close
        end
    end

    def get_hash(key)
        url = "#{@url}/get/#{key}"
        headers = { 'Authorization': "Bearer #{@token}" }
        internet = Async::HTTP::Internet.new

        begin
            response = Async::Task.current.with_timeout(3) do
                internet.get(url, headers)
            end

            return {} unless response.success?

            body = response.read
            result = JSON.parse(body)['result']

            return {} if result.nil?

            JSON.parse(result).to_h
        ensure            
            internet.close
        end
    end
end

def emoji_flag(country_code)
  cc = country_code.to_s.upcase
  return unless cc =~ /\A[A-Z]{2}\z/

  cc.codepoints.map { |c| (c + 127397).chr(Encoding::UTF_8) }.join
end