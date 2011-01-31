#this is a simple example on how to access your 7digital locker using 3-legged oauth

require '../lib/sevendigital'
#require "7digital"

sd_client = Sevendigital::Client.new("sevendigital.yml")

request_token = sd_client.oauth.get_request_token
access_token = nil

while !access_token
  puts "Please go to the bellow URL to authorize access to your locker:"
  puts "#{request_token.authorize_url(:oauth_callback=>"http://example.com/callback_handler")}"
  puts "Once done, press any key to continue"
  gets
  begin
    access_token = sd_client.oauth.get_access_token(request_token)
  rescue Sevendigital::SevendigitalError => error
    puts "ERROR: #{error.error_message}"
    puts "Please make sure you have authorised the demo app." if error.error_code == 2002
  end
end

user = sd_client.user.login(access_token)

locker = user.locker(:sort => "purchaseDate desc")

puts "Your latest 7digital purchases:\n"

locker.locker_releases.each do |locker_release|
  puts "#{locker_release.release.artist.appears_as} - #{locker_release.release.title}:"
  locker_release.locker_tracks.each do |locker_track|
    puts "  #{locker_track.track.title} - download link: #{locker_track.download_urls.first.url}"
  end
end