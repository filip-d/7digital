require "spec_helper"

describe "Sevendigital Gem" do

  before do
    @api_client = Sevendigital::Client.new(
          :oauth_consumer_key => "YOUR_KEY_HERE",
          :oauth_consumer_secret => "YOUR_SECRET_HERE",
          :lazy_load => true,
          :country => "GB",
          :verbose => "verbose"
     )
  end

  it "should find an artist" do
    @api_client.artist.search("keane").first.name.should == "Keane"
  end

  it "should find at least 20 releases" do
    releases = @api_client.release.search("love", :page_size => 20, :page=>2)
    releases.size.should == 20
    releases.current_page.should == 2
    releases.total_entries.should > 100
    releases.first.price.value.should > 0
  end

  it "should find a track with price" do
    track = @api_client.track.search("radiohead creep").first
    track.artist.appears_as.should == "Radiohead"
    track.release.price.value.should > 1
    track.price.value.should > 0
  end

end
