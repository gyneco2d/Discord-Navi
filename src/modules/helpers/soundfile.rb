require 'net/http'
require 'uri'
require 'json'
require 'base64'

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

      payload = {
        "audioConfig": {
          "audioEncoding": "MP3",
          "pitch": "0.00",
          "speakingRate": "1.00"
        },
        "input": {
          "text": "#{username} joined your channel!"
        },
        "voice": {
          "languageCode": "en-US",
          "name": "en-US-Wavenet-F"
        }
      }.to_json

      req.body = payload
      res = https.request(req)
      content = JSON.parse res.body

      File.open("data/soundfiles/#{username}.mp3", 'w').write(Base64.decode64 content["audioContent"])
    end
  end
end
