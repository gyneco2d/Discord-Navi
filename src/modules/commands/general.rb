require 'discordrb'

require_relative '../helpers/general'

module Bot::Commands
  module General
    extend Discordrb::Commands::CommandContainer
    command :hello do |event|
      event.respond "Hello, #{event.user.name}"
    end

    command :kuji do |event|
      # Get command user's voice channel
      voice_channel = nil
      event.server.channels.each do |channel|
        if channel.type == 2
          channel.users.each do |user|
            if user.id == event.user.id
              voice_channel = channel
            end
          end
        end
      end
      if !voice_channel
        event.bot.send_message(event.channel.id, "You are not in any voice channel")
        return
      end
      # Get voice channel members
      member = []
      voice_channel.users.each do |user|
        member.push(user) if !user.bot_account
      end
      # Select one at random
      selected = Helpers::General.shuffle(member)[0].name
      event.bot.send_message(event.channel.id, selected)
    end
  end
end
