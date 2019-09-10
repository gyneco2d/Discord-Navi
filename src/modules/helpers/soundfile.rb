require 'base64'
require 'fileutils'
require 'json'
require 'net/http'
require 'uri'
require 'miyabi'

module Helpers
  module Soundfile

    module_function

    def request(username, channel)
      uri = URI.parse('https://texttospeech.googleapis.com/v1beta1/text:synthesize')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      req = Net::HTTP::Post.new(uri.request_uri)
      req['Authorization'] = 'Bearer '.concat(`gcloud auth application-default print-access-token`.chomp)
      req['Content-Type'] = 'application/json; charset=utf-8'

      # Cloud Text-to-Speech API / Method: text.synthesize
      # https://cloud.google.com/text-to-speech/docs/reference/rest/v1beta1/text/synthesize
      alphabeted = username.is_japanese? ? username.to_roman : username
      payload = {
        "audioConfig": {
          "audioEncoding": "MP3",
          "pitch": "0.00",
          "speakingRate": "1.00"
        },
        "input": {
          "text": "#{alphabeted} joined your channel!"
        },
        "voice": {
          "languageCode": "en-US",
          "name": "en-US-Wavenet-F"
        }
      }.to_json
      req.body = payload

      begin
        response = https.request(req)

        case response
        when Net::HTTPSuccess
          content = JSON.parse(response.body)

          FileUtils.mkdir_p('data/soundfiles/') unless File.exist?('data/soundfiles/')
          soundfile = File.open("data/soundfiles/#{username}.mp3", 'w')
          soundfile.write(Base64.decode64(content["audioContent"]))
          soundfile.sync = true
        else
          puts [uri.to_s, response.value].join(" : ")
          nil
        end
      rescue => e
        puts [uri.to_s, e.class, e].join(" : ")
        nil
      end
    end
  end
end
