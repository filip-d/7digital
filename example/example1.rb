require '../lib/sevendigital'

  client = Sevendigital::Client.new(:oauth_consumer_key => "YOUR_KEY_HERE", :lazy_load? => true, :country => "ES")

  artist = client.artist.get_details(1)

  puts artist.name

  artist.releases.each do |release|
    puts release.year.to_s + " - " + release.title
    puts release.tracks.size.to_s + " tracks for " + release.price.formatted_price
  end

  recommendations = client.release.get_top_by_tag("alternative-indie")

  recommendations.each do |release|
    puts "\n"
    puts "#{release.artist.name} - #{release.title} (#{release.year})"
    puts "Barcode: #{release.barcode}, explicit content: #{release.explicit_content}, formats: #{release.formats.collect {|format| format.file_format}}"
    puts "Label: #{release.label.name}"
    puts release.tracks.size.to_s + " tracks for " + release.price.formatted_price
  end


