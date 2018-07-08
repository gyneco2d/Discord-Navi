require 'discordrb'
require 'net/http'
require 'uri'
require 'json'
require 'base64'

require_relative '../helpers/soundfile'

module Bot::Events
  module JoinAnnouncer
    extend Discordrb::EventContainer

    voice_state_update do |event|
      if !event.user.bot_account
        # get default text channel
        begin
          default_text_channel = nil
          event.server.channels.each do |channel|
            if channel.type == 0
              default_text_channel ||= channel.id
              default_text_channel = channel.id if channel.name == 'general'
            end
          end
          exit unless default_text_channel
        rescue SystemExit => err
          puts "There is no text channel. Bot is shutting down."
          exit(1)
        end

        # notify only when joining any channel
        if event.old_channel.nil?
          # text notification
          text = ""
          text << event.user.name
          text << " joined "
          text << event.channel.name
          text
          event.bot.send_message(default_text_channel, text)

          # voice notification
          if !File.exist?("data/soundfiles/#{event.user.name}.mp3")
            Helpers::Soundfile.request(event.user.name, event.channel.name)
          end
          voice_bot = event.bot.voice_connect(event.channel.id)
          voice_bot.volume = 1 #default
          voice_bot.play_file "data/soundfiles/#{event.user.name}.mp3"
          voice_bot.destroy
        end
      end
    end
  end
end
