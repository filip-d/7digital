require '../lib/sevendigital'
require "./very_simple_cache"

#CACHE = Dalli::Client.new('localhost:11211', :namespace => 'myapp')

api_client = Sevendigital::Client.new("sevendigital.yml", :cache=>VerySimpleCache.new, :verbose => "verbose")

total_items = api_client.artist.get_top_by_tag("rock", {:page => 1, :page_size => 1}).total_entries
sleep 5
total_items2 = api_client.artist.get_top_by_tag("rock", {:page => 1, :page_size => 1}).total_entries

puts total_items
puts total_items2

