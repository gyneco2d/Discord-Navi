require 'discordrb'
require 'ostruct'
require 'json'

module Bot

  CONFIG = OpenStruct.new(JSON.parse(File.open('config.json').read))
  BOT = Discordrb::Commands::CommandBot.new(token: CONFIG.token, client_id: CONFIG.client_id, prefix: '!')

  def self.load_modules(cls, path)
    new_module = Module.new
    const_set(cls.to_sym, new_module)
    Dir["src/modules/#{path}/*rb"].each { |file| load file }
    new_module.constants.each do |mod|
      BOT.include! new_module.const_get(mod)
    end
  end

  load_modules(:Events, 'events')

  BOT.run
end
