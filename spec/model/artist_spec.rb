require "date"
require File.expand_path('../../spec_helper', __FILE__)

describe "Artist" do

  before do
    @client = stub(Sevendigital::Client)
    @artist_manager = mock(Sevendigital::ArtistManager)
    @client.stub!(:artist).and_return @artist_manager
    
    @artist = Sevendigital::Artist.new(@client)
    @artist.id = 1234
  end

  it "get_details should get artist's basic details from manager" do
    expected_options = {:page => 2}
    fresh_artist = fake_artist_with_details

    @artist_manager.should_receive(:get_details) { |artist_id, options|
      artist_id.should == @artist.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fresh_artist
    }
    @artist.get_details(expected_options).should == fresh_artist
    
    @artist.sort_name.should == fresh_artist.sort_name
    @artist.image.should == fresh_artist.image
    @artist.url.should == fresh_artist.url
   
  end

  it "get_releases should get releases from manager" do
    expected_options = {:page => 2}
   
    @artist_manager.should_receive(:get_releases) { |artist_id, options|
      artist_id.should == @artist.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_release_list
    }
    @artist.get_releases(expected_options)

  end

   it "get_top_tracks should get tracks from manager" do
    expected_options = {:page => 2}
   
    @artist_manager.should_receive(:get_top_tracks) { |artist_id, options|
      artist_id.should == @artist.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_track_list
    }
    @artist.get_top_tracks(expected_options)

  end

   it "get_similar should get similar artists from manager" do
    expected_options = {:page => 2}

    @artist_manager.should_receive(:get_similar) { |artist_id, options|
      artist_id.should == @artist.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_artist_list
    }
    @artist.get_similar(expected_options)

   end

  it "get_tags should get tags from manager" do
    expected_options = {:page => 2}

    @artist_manager.should_receive(:get_tags) { |artist_id, options|
      artist_id.should == @artist.id
      (options.keys & expected_options.keys).should == expected_options.keys
      []
    }
    @artist.get_tags(expected_options)

  end


  it "should be a various artist if name contains various" do

    @artist.name = "various"
    @artist.various?.should == true

  end

  it "should be a various artist if appears as contains various" do

    @artist.name = "mr"
    @artist.appears_as = "mr various"
    @artist.various?.should == true

  end

  it "should be a various artist if resembles various artist" do

    @artist.name = "v.a."
    @artist.various?.should == true
    @artist.name = "vario"
    @artist.various?.should == true
    @artist.name = "vaious"
    @artist.various?.should == true
    @artist.name = "varios"
    @artist.various?.should == true
    @artist.name = "aaaa"
    @artist.various?.should == false
    @artist.name = "vaious"
    @artist.various?.should == true
    @artist.name = "varoius"
    @artist.various?.should == true
    @artist.name = "variuos"
    @artist.various?.should == true

  end

  it "should not be a various artist if it doesn't resemble various artist" do

    @artist.name = "mr small"
    @artist.appears_as = "mr big"
    @artist.various?.should == false

  end

  it "image should return link to image with specified image size" do
    artist = fake_artist_with_details
    artist.image(333).should == "http://cdn.7static.com/static/img/artistimages/00/000/000/0000000001_333.jpg"
  end

  it "image should return link to image with returned image size" do
    artist = fake_artist_with_details
    artist.image.should == "http://cdn.7static.com/static/img/artistimages/00/000/000/0000000001_300.jpg"
  end

  def fake_track_list
    tracks = Array.new
    tracks << Sevendigital::Track.new(@client)
    tracks << Sevendigital::Track.new(@client)
    tracks
  end

  def fake_release_list
    releases = Array.new
    releases << Sevendigital::Release.new(@client)
    releases << Sevendigital::Release.new(@client)
    releases
  end

  def fake_artist_list
    artists = Array.new
    artists << Sevendigital::Artist.new(@client)
    artists << Sevendigital::Artist.new(@client)
    artists
  end

  def fake_artist_with_details
    artist = Sevendigital::Artist.new(@client)
    artist.sort_name = "The, The"
    artist.image = "http://cdn.7static.com/static/img/artistimages/00/000/000/0000000001_300.jpg"
    artist.url = "url"
    artist
  end
end