require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "DownloadUrlDigestor" do

  before do
     @download_url_digestor = Sevendigital::DownloadUrlDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
<zzz id="17">
	<fileFormat>MP3</fileFormat>
	<bitRate>320</bitRate>
	<drmFree>True</drmFree>
</zzz>
XML

    running {@download_url_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate all properties" do

    xml_response = <<XML
<downloadUrl>
  <url>http://media3.7digital.com/media/user/downloadtrack?</url>
  <format id="17">
    <fileFormat>MP3</fileFormat>
    <bitRate>320</bitRate>
    <drmFree>true</drmFree>
  </format>
</downloadUrl>
XML

    download_url = @download_url_digestor.from_xml(xml_response)
    download_url.url.should == "http://media3.7digital.com/media/user/downloadtrack?"
    download_url.format.id.should == 17
    download_url.format.file_format.should == :MP3
  end

end