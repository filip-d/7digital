# coding: utf-8
require 'date'
require File.expand_path('../../spec_helper', __FILE__)

describe "LockerTrackDigestor" do

  before do
    @locker_track_digestor = Sevendigital::LockerTrackDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    running {@locker_track_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

   it "should digest locker track xml and populate all available properties" do

    xml_response = load_sample_object_xml("locker_track")
    
    locker_track = @locker_track_digestor.from_xml_string(xml_response)

    locker_track.track.id.should == 3544116
    locker_track.track.title.should == "Gloria"
    locker_track.remaining_downloads.should == 355
    locker_track.purchase_date.should == DateTime.new(2009,7,22,11,41,41, 1.quo(24))
    locker_track.download_urls.size.should == 1
    locker_track.download_urls[0].url.should == "http://media3.7digital.com/media/user/downloadtrack?"

  end

  it "should digest xml containing single item list of locker tracks and return an array" do

    xml_response = load_sample_object_xml("locker_track_list")

    locker_tracks = @locker_track_digestor.list_from_xml_string(xml_response)
    locker_tracks[0].track.id.should == 3544116
    locker_tracks[0].download_urls[0].url.should == "http://media3.7digital.com/media/user/downloadtrack?"
    locker_tracks.size.should == 1
  end

  it "should digest xml containing empty list of locker tracks and return an empty array" do

    xml_response = load_sample_object_xml("locker_track_list_empty")

    locker_tracks = @locker_track_digestor.list_from_xml_string(xml_response)
    locker_tracks.size.should == 0

  end

end
