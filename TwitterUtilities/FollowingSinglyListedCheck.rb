require 'twitter'
require 'yaml'
settings = YAML::load_file("settings.yml")["settings"]

client = Twitter::REST::Client.new do |config|
  config.consumer_key        = settings["consumer_key"]
  config.consumer_secret     = settings["consumer_secret"]
  config.access_token        = settings["access_token"]
  config.access_token_secret = settings["access_token_secret"]
end

h = Hash.new { [] }

client.friends.each do |friend|
  h[friend.handle] += ["Following"]
end

client.owned_lists.each do |list|
  members = client.list_members list.id
  members.each do |member|
    h[member.handle] += [list.name]
  end
end

h.delete_if {|key, value| value.count == 2 && value.include?("Following") }

if(h.count == 0)
  puts "All clean!"
else
  puts "Exceptions:"
  h.each do |item|
    puts "#{item[0]} : #{item[1]} : https://twitter.com/#{item[0]}"
  end
end
