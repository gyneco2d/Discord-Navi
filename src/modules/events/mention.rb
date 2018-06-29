require 'discordrb'

module Bot::Events
  module Mention
    extend Discordrb::EventContainer
    mention(contains: /(Hello|Hi)/i) do |event|
      event.respond "Hello, #{event.user.name}"
    end
  end
end
