require "spec"
require "date"
require 'sevendigital'

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
    @artist.get_details(expected_options)
    
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

  it "get_releases should link all releases back to artist itself" do

    @artist_manager.should_receive(:get_releases) { |artist_id, options|
      artist_id.should == @artist.id
      fake_release_list
    }

    releases = @artist.get_releases()
    releases.all?{|release| release.artist == @artist}.should == true

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

  it "get_top_tracks should link all tracks back to artist itself" do

    @artist_manager.should_receive(:get_top_tracks) { |artist_id, options|
      artist_id.should == @artist.id
      fake_track_list
    }

    tracks = @artist.get_top_tracks()

    tracks.all?{|track| track.artist == @artist}.should == true

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
    artist.image = "image"
    artist.url = "url"
    artist
end
end