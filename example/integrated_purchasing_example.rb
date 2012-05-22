require '../lib/sevendigital'
require './very_simple_cache'

api_client = Sevendigital::Client.new("sevendigital.yml", :cache => VerySimpleCache.new)

track = api_client.track.search("TEST CONTENT - TEST CONTENT", :page_size=>1).first


user = api_client.user.authenticate("USERS_EMAIL", "USERS_PASSWORD")

puts "purchasing track #{track.title} by #{track.artist.appears_as} from #{track.release.title}"
puts "the price is #{track.price.formatted_price}"

purchase_response = user.purchase!(track.release.id, track.id, track.price.value) if track.price.value

locker_track = purchase_response.locker_releases.first.locker_tracks.first

puts "you can now download the track here: #{locker_track.download_urls.first.url}"
