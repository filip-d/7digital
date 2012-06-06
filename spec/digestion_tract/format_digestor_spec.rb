require File.expand_path('../../spec_helper', __FILE__)

describe "FormatDigestor" do

  before do
     @format_digestor = Sevendigital::FormatDigestor.new(nil)
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
<zzz id="17">
	<fileFormat>MP3</fileFormat>
	<bitRate>320</bitRate>
	<drmFree>True</drmFree>
</zzz>
XML

    running {@format_digestor.from_xml_nokogiri(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate all properties" do

    xml_response = <<XML
<format id="17">
	<fileFormat>MP3</fileFormat>
	<bitRate>320</bitRate>
	<drmFree>True</drmFree>
</format>
XML

    format = @format_digestor.from_xml_nokogiri(xml_response)
    format.id.should == 17
    format.file_format.should == :MP3
    format.bit_rate.should == 320
    format.drm_free.should == true
  end

end