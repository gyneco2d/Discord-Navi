require 'discordrb'

module Bot::Commands
  module General
    extend Discordrb::Commands::CommandContainer
    command :hello do |event|
      event.respond "Hello, #{event.user.name}"
    end
  end
end
