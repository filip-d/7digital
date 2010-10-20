require '../lib/sevendigital'

class VerySimpleCache < Hash
  def set(key, value) store(key, value);  end
  def get(key) has_key?(key) ? fetch(key) : nil;  end
end

  api_client = Sevendigital::Client.new(
          :oauth_consumer_key => "YOUR_KEY_HERE",
          :oauth_consumer_secret => "YOUR_SECRET_HERE",
          :lazy_load? => true,
          :country => "GB",
          #:cache => VerySimpleCache.new,
          :verbose => "verbose"
  )

  track = api_client.track.search("TEST CONTENT - TEST CONTENT", :page_size=>1).first

  puts "purchasing track #{track.title} by #{track.artist.appears_as} from #{track.release.title}"
  puts "the price is #{track.price.formatted_price}"

  user = api_client.user.authenticate("USERS_EMAIL", "USERS_PASSWORD")

  purchase_response = user.purchase!(track.release.id, track.id, track.price.value) if track.price.value

  locker_track = purchase_response.locker_releases.first.locker_tracks.first

  puts "you can now download the track here: #{locker_track.download_urls.first.url}"
