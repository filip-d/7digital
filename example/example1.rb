require '../lib/sevendigital'

class VerySimpleCache < Hash
  def set(key, value) store(key, value);  end
  def get(key) has_key?(key) ? fetch(key) : nil;  end
end

  sevendigital_client = Sevendigital::Client.new(
          :oauth_consumer_key => "7digital_mobile",
          :oauth_consumer_secret => "0a41737acfeba433",
          :lazy_load? => true,
          :country => "GB",
          :cache => VerySimpleCache.new,
          :verbose => "very_verbose"
  )

#  artist = sevendigital_client.artist.search("radiohead").first
#  artist = sevendigital_client.artist.get_details(1)


user = sevendigital_client.user.authenticate("filip%407digital.com", "aaa")

puts user.oauth_access_token

#  puts artist.name

  sevendigital_client.track.search("radiohead").each do |track|
    puts "#{track.title} [#{track.version}]"
    puts track.release.year.to_s + " - " + track.release.title
#    puts release.tracks.size.to_s + " tracks for " + release.price.formatted_price
  end


  sevendigital_client.release.search("radiohead").each do |release|
    puts release.year.to_s + " - " + release.title
    puts release.tracks.size.to_s + " tracks for " + release.price.formatted_price
  end

  recommendations = sevendigital_client.release.get_top_by_tag("alternative-indie")

  recommendations.each do |release|
    puts "\n"
    puts "#{release.artist.name} - #{release.title} (#{release.year})"
    puts "Barcode: #{release.barcode}, explicit content: #{release.explicit_content}, formats: #{release.formats.collect {|format| format.file_format}}"
    puts "Label: #{release.label.name}"
    puts release.tracks.size.to_s + " tracks for " + release.price.formatted_price
  end

