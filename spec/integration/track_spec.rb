# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)
require 'date'

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
# not working yet on 7digital API    tracks.first.price.value.should > 0
  end

end
