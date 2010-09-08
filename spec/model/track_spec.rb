require "spec"
require "date"
require 'sevendigital'

describe "Track" do

  before do
    @client = stub(Sevendigital::Client)
    @track_manager = mock(Sevendigital::TrackManager)
    @client.stub!(:track).and_return @track_manager
    
    @track = Sevendigital::Track.new(@client)
    @track.id = 1234
  end

  it "get_details should get track's basic details from manager" do
    expected_options = {:page => 2}
    fresh_track = fake_track_with_details

    @track_manager.should_receive(:get_details) { |track_id, options|
      track_id.should == @track.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fresh_track
    }
    @track.get_details(expected_options)
    
    @track.track_number.should == fresh_track.track_number
    @track.duration.should == fresh_track.duration
    @track.explicit_content.should == fresh_track.explicit_content
    @track.isrc.should == fresh_track.isrc
    @track.release.should == fresh_track.release
    @track.url.should == fresh_track.url

  end

  it "should have a short title without any version in brackets" do

    @track.title = "track 1 (lp version)"
    @track.short_title.should == "track 1"
    @track.title = "(lp version)"
    @track.short_title.should == "(lp version)"
    @track.title = "track 1 (something else)"
    @track.short_title.should == "track 1 (something else)"
    @track.title = "track 1 (dj remix)"
    @track.short_title.should == "track 1"
    @track.title = "track  1  (  dj mix  )"
    @track.short_title.should == "track  1"
  end

  describe "similar?" do

    before do
      @artist1 = Sevendigital::Artist.new(@client)
      @artist2 = Sevendigital::Artist.new(@client)
      @track1 = Sevendigital::Track.new(@client)
      @track1.artist = @artist1
      @track2 = Sevendigital::Track.new(@client)
      @track2.artist = @artist2

      @artist1.name = "artist 1"
      @track1.title = "track 1"

    end

    it "should be similar to another track if artist names and titles match"  do
      @artist2.name = "Artist 1"
      @track2.title = "Track 1"

      @track1.similar?(@track2).should == true
    end

    it "should be similar to another track if artist names and short titles match"  do
      @track1.title = "track 1 (uk version)"
     
      @artist2.name = "Artist 1"
      @track2.title = "TRACK 1 (us remix)"

      @track1.similar?(@track2).should == true
    end

    it "should not be similar to another track if artist names don't match" do
      @artist2.name = "artist 2"
      @track2.title = "track 1"

      @track1.similar?(@track2).should == false
    end

    it "should not be similar to another track if short titles match" do
      @artist2.name = "artist 1"
      @track2.title = "track 2"

      @track1.similar?(@track2).should == false
    end


  end

  def fake_track_with_details
    track = Sevendigital::Track.new(@client)
    track.title = "Song 1"
    track.version = "Version 2"
    track.artist = Sevendigital::Artist.new(@client)
    track.track_number = 7
    track.duration = 77
    track.explicit_content = true
    track.isrc = "7D"
    track.release = Sevendigital::Release.new(@client)
    track.url = "http://aaa.bbb.ccc/"
    track
  end
end