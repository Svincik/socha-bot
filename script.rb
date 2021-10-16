require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'discordrb'
require 'open-uri'
require 'fileutils'
require 'securerandom'
require 'net/http'
require 'json'

$settings = YAML.load(File.read "config.yaml")['settings']
bot = Discordrb::Commands::CommandBot.new token: $settings['token'], prefix: $settings['prefix']

bot.message(contains: "soch") do |event|
  event.respond 'https://cdn.discordapp.com/emojis/882892339566227466.png'
  event.message.reactions
end

bot.command(:ping) do |event|
  m = event.respond('Pong!')
  m.edit "Pong! Time taken: #{Time.now - event.timestamp} seconds."
end

bot.command(:neko, description: "Requests nekos.") do |_event, keyword|
  url = "https://nekos.life/api/v2/img/"
  options = ["meow", "woof", "tickle", "feed", "poke", "slap", "avatar", "waifu",
             "lizard", "pat", "kiss", "neko", "cuddle", "hug", "lewd"]
  if options.include? keyword then
      response = JSON.parse(Net::HTTP.get(URI("#{url}#{keyword}")))
      "Here's your lewds!  °˖✧◝(⁰▿⁰)◜✧˖°\n#{response['url']}"
  else
      "No such tag. Please specify one of `#{options.join(", ")}`"
  end
end
def save_settings
  File.open("config.yaml", 'w') do |file|
    file.write(YAML.dump({'settings' => $settings}))
  end
end

bot.run