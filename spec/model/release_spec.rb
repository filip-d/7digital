require "date"
require File.expand_path('../../spec_helper', __FILE__)

describe "Release" do

  before do
    @configuration = stub(OpenStruct)
    @configuration.stub!(:lazy_load).and_return(true)

    @client = stub(Sevendigital::Client)
    @client.stub!(:configuration).and_return(@configuration)
    @release_manager = mock(Sevendigital::ReleaseManager)
    @client.stub!(:release).and_return @release_manager
    
    @release = Sevendigital::Release.new(@client)
    @release.id = 1234
  end

  it "should get its basic details from manager" do
    expected_options = {:page => 2}
    fresh_release = fake_release_with_details

    @release_manager.should_receive(:get_details) { |release_id, options|
      release_id.should == @release.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fresh_release
    }
    @release.get_details(expected_options)
    
    @release.version.should == fresh_release.version
    @release.type.should == fresh_release.type
    @release.artist.should == fresh_release.artist
    @release.image.should == fresh_release.image
    @release.url.should == fresh_release.url
    @release.release_date.should == fresh_release.release_date
    @release.added_date.should == fresh_release.added_date
    @release.barcode.should == fresh_release.barcode
    @release.year.should == fresh_release.year
    @release.explicit_content.should == fresh_release.explicit_content
    @release.formats.should == fresh_release.formats
    @release.label.should == fresh_release.label
    @release.price.should == fresh_release.price

  end

  it "should lazy load price even if already populated but price value is not available" do
    @release.price = Sevendigital::Price.new
    @release.should_receive(:demand_price)
    @release.price

  end

  it "get_tracks should get tracks from manager" do
    expected_options = {:page => 2}
   
    @release_manager.should_receive(:get_tracks) { |release_id, options|
      release_id.should == @release.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_track_list
    }
    @release.get_tracks(expected_options)

  end


   it "get_recommendations should get recommendations from manager" do
    expected_options = {:page => 2}

    @release_manager.should_receive(:get_recommendations) { |release_id, options|
      release_id.should == @release.id
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_releases_list
    }
    @release.get_recommendations(expected_options)

   end

    it "get_tags should get tags from manager" do
    expected_options = {:page => 2}

    @release_manager.should_receive(:get_tags) { |release_id, options|
      release_id.should == @release.id
      (options.keys & expected_options.keys).should == expected_options.keys
      []
    }
    @release.get_tags(expected_options)

    end

  it "image should return link to image with specified image size" do
    release = fake_release_with_details
    release.image(333).should == "http://cdn.7static.com/static/img/sleeveart/00/008/097/0000809794_333.jpg"
  end

  it "image should return link to image with returned image size" do
    release = fake_release_with_details
    release.image.should == "http://cdn.7static.com/static/img/sleeveart/00/008/097/0000809794_100.jpg"
  end


  def fake_releases_list
    releases = Array.new
    releases << Sevendigital::Release.new(@client)
    releases << Sevendigital::Release.new(@client)
    releases
  end

  def fake_track_list
    tracks = Array.new
    tracks << Sevendigital::Track.new(@client)
    tracks << Sevendigital::Track.new(@client)
    tracks
  end

  def fake_release_with_details
    release = Sevendigital::Release.new(@client)
    release.version = "(release version)"
    release.type = :album
    release.artist = Sevendigital::Artist.new(@client)
    release.image = "http://cdn.7static.com/static/img/sleeveart/00/008/097/0000809794_100.jpg"
    release.url = "url"
    release.release_date = DateTime.new(2010, 1, 1)
    release.added_date = DateTime.new(2000, 1, 1)
    release.barcode = "AAA"
    release.year = 1999
    release.explicit_content = true
    release.formats = []
    release.label = Sevendigital::Label.new
    price = Sevendigital::Price.new
    price.value = 5
    release.price = price
    release
end
end