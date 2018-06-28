require 'discordrb'

module Bot::Events
  module JoinAnnouncer
    extend Discordrb::EventContainer

    voice_state_update do |event|
      # get default text channel
      begin
        default_channel = nil
        event.server.channels.each do |channel|
          if channel.type == 0
            default_channel ||= channel.id
            default_channel = channel.id if channel.name == 'general'
          end
        end
        exit unless default_channel
      rescue SystemExit => err
        puts "There is no text channel. Bot is shutting down."
        exit(1)
      end

      # notify only when joining any channel
      if event.old_channel == nil
        text = ""
        text << event.user.name
        text << " joined "
        text << event.channel.name
        text

        event.bot.send_message(default_channel, text)
      end
    end
  end
end
