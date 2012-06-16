require File.expand_path('../../spec_helper', __FILE__)

describe "LockerDigestor" do

  before do
     @locker_digestor = Sevendigital::LockerDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
<zzz id="17">
	<fileFormat>MP3</fileFormat>
	<bitRate>320</bitRate>
	<drmFree>True</drmFree>
</zzz>
XML

    running {@locker_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("locker")

    locker = @locker_digestor.from_xml_string(xml_response)
    locker.locker_releases.size.should == 1
    locker.locker_releases[0].release.id.should == 302123
  end

end