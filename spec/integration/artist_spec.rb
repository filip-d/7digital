# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)

describe "Artist integration test" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should browse artists" do
    artists = @api_client.artist.browse("KEA")
    artists.current_page.should == 1
    artists.total_entries.should >= 1
    artists.each do |artist|
      artist.name[0..2].downcase.should == "kea"
      artist.id.should >= 1
      artist.url.should =~ VALID_7DIGITAL_URL
    end
  end

  it "should get artist chart" do
    chart = @api_client.artist.get_chart(:period => :year, :toDate => 20111231)
    chart.current_page.should == 1
    chart.total_entries.should >= 20
    chart.first.position.should == 1
    chart.last.position.should == 10
    chart.first.item.id.should == 142111
    chart.first.item.name.should == "Adele"
 end

  it "should get artist details" do
    artist = @api_client.artist.get_details(1)
    artist.name.should == "Keane"
    artist.id.should == 1
  end

  it "should get artist releases" do
    releases = @api_client.artist.get_details(1).get_releases(:type => :single)
    releases.current_page.should == 1
    releases.total_entries.should >= 1
    releases.each do |release|
      release.artist.name.should == "Keane"
      release.id.should >= 1
      release.title.should_not be_empty
      release.label.should_not be_nil
      release.year.should >= 1990
      release.type.should == :single
    end
   end

  it "should search and find an artist" do
    artists = @api_client.artist.search("keane")
    artists.current_page.should == 1
    artists.total_entries.should >= 1
    artists.first.name.should == "Keane"
    artists.first.id.should == 1
  end

  it "should get top tracks" do
    tracks = @api_client.artist.get_details(1).get_top_tracks
    tracks.current_page.should == 1
    tracks.total_entries.should >= 1
    tracks.each do |track|
      track.artist.name.should == "Keane"
      track.id.should >= 1
      track.title.should_not be_empty
      track.release.should_not be_nil
    end
  end

  it "should get similar artists" do
    artists = @api_client.artist.get_details(1).get_similar
    artists.current_page.should == 1
    artists.total_entries.should >= 1
    artists.each do |artist|
      artist.name.should_not be_empty
      artist.id.should >= 1
      artist.url.should =~ VALID_7DIGITAL_URL
    end
  end

end
