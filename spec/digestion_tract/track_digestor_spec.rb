# coding: utf-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "TrackDigestor" do

  before do
    @track_digestor = Sevendigital::TrackDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    running {@track_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should digest track xml and populate minimum available properties" do

    xml_response = <<XML
    <track id="123">
      <title>expected track title</title>
			<artist id="345">
				<name>expected artist name</name>
				<appearsAs>expected displayed artist name</appearsAs>
			</artist>
    </track>
XML

    track = @track_digestor.from_xml_string(xml_response)
    track.id.should == 123
    track.title.should == "expected track title"
    track.artist.id.should == 345
    track.artist.name.should == "expected artist name"
    track.artist.appears_as == "expected displayed artist name"
  end

   it "should digest track xml and populate all available properties" do

    xml_response = load_sample_object_xml("track")

    track = @track_digestor.from_xml_string(xml_response)
    track.id.should == 1628015
    track.title.should == "Burning"
    track.version.should == ""
    track.artist.id.should == 29755
    track.artist.name.should == "The Whitest Boy Alive"
    track.artist.appears_as.should == "The Whitest Boy Alive"
    track.track_number.should == 1
    track.duration.should == 189
    track.explicit_content.should == false
    track.isrc.should == "DED620600065"
    track.release.id.should == 155408
    track.release.title.should == "Dreams"
    track.price.currency_code.should == :GBP
    track.price.currency_symbol.should == "£"
    track.price.value.should == 0.79
    track.price.formatted_price.should == "£0.79"
    track.price.rrp.should == 0.79
    track.price.formatted_rrp.should == "£0.79"
    track.price.on_sale.should == false
    track.url.should == "http://www.7digital.com/artists/the-whitest-boy-alive/dreams-1/01-Burning/?partner=123"
    track
  end

  it "should digest xml containing list of tracks and return an array" do

    xml_response = <<XML
  <results>
    <page>1</page>
    <pageSize>2</pageSize>
    <totalItems>50</totalItems>
    <track id="123">
      <title>expected track title</title>
      <artist id="345">
        <name>expected artist name</name>
        <appearsAs>expected displayed artist name</appearsAs>
      </artist>
    </track>
    <track id="456">
      <title>expected track title</title>
      <artist id="789">
        <name>expected artist name</name>
        <appearsAs>expected displayed artist name</appearsAs>
      </artist>
    </track>
  </results>
XML

    tracks = @track_digestor.list_from_xml_string(xml_response, :results)
    tracks[0].id.should == 123
    tracks[0].artist.id.should == 345
    tracks[1].id.should == 456
    tracks[1].artist.id.should == 789
    tracks.size.should == 2
    tracks.total_entries.should == 50


  end

end