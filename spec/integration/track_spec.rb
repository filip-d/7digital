# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)
require 'date'
require 'net/http'

describe "Track integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should search and find a track with a price" do
    tracks = @api_client.track.search("radiohead creep")
    tracks.current_page.should == 1
    tracks.first.artist.appears_as.should == "Radiohead"
    tracks.first.release.should_not be_nil
    tracks.first.type.should == :audio
# not working yet on 7digital API    tracks.first.price.value.should > 0
  end

  it "should provide a working preview clip link" do
    track = @api_client.track.get_details(123456)

    res = Net::HTTP.get_response(URI.parse(track.preview_url))

#    req = Net::HTTP::Get.new(track.preview_url)
 #   res =     http.request(req)
 #   }
    res["Content-Type"].should == "audio/mpeg"


  end

end
