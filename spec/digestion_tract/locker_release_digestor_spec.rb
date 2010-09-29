# coding: utf-8
require 'date'
require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "LockerReleaseDigestor" do

  before do
    @locker_release_digestor = Sevendigital::LockerReleaseDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <artist id="123">
      <name>expected artist name</name>
    </artist>
XML

    running {@locker_release_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

   it "should digest locker release xml and populate all available properties" do

    xml_response = load_sample_object_xml("locker_release")
    puts @locker_release_digestor
    
    locker_release = @locker_release_digestor.from_xml(xml_response)

    locker_release.release.id.should == 302123
    locker_release.release.title.should == "Original Album Classics"
    locker_release.locker_tracks.size.should == 1
    locker_release.locker_tracks[0].track.id.should == 3544116
    locker_release.locker_tracks[0].track.title.should == "Gloria"
    locker_release.locker_tracks[0].remaining_downloads.should == 355
    locker_release.locker_tracks[0].download_urls.url.should == "http://media3.7digital.com/media/user/downloadtrack?"

  end

  it "should digest xml containing list of locker releases and return a paginated array" do

    xml_response = load_sample_object_xml("locker_release_list")

    locker_releases = @locker_release_digestor.list_from_xml(xml_response, :locker_releases)
    locker_releases[0].release.id.should == 302123
    locker_releases[0].locker_tracks[0].track.id.should == 3544116
    locker_releases.size.should == 2
    locker_releases.total_entries.should == 50

  end

  it "should digest xml containing single item list of locker releases and return a paginated array" do

    xml_response = load_sample_object_xml("locker_release_list")

    releases = @locker_release_digestor.list_from_xml(xml_response, :locker_releases)
   locker_releases[0].release.id.should == 302123
    locker_releases[0].locker_tracks[0].track.id.should == 3544116
    locker_releases.size.should == 1
    locker_releases.total_entries.should == 1
  end

  it "should digest xml containing empty list of locker releases and return an empty paginated array" do

    xml_response = load_sample_object_xml("locker_release_list_empty")

    locker_releases = @locker_release_digestor.list_from_xml(xml_response, :locker_releases)
    locker_releases.size.should == 0
    locker_releases.total_entries.should == 0

  end

end
