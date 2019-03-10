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
      res = https.request(req)
      content = JSON.parse(res.body)

      FileUtils.mkdir_p('data/soundfiles/') unless File.exist?('data/soundfiles/')
      File.open("data/soundfiles/#{username}.mp3", 'w').write(Base64.decode64(content["audioContent"]))
    end
  end
end
