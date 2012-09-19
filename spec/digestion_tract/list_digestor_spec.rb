require File.expand_path('../../spec_helper', __FILE__)

describe "ListDigestor" do

  before do
     @list_digestor = Sevendigital::ListDigestor.new(Sevendigital::Client.new(nil))
  end

  it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
<zzz id="17">
	<aaa>MP3</aaa>
</zzz>
XML

    running {@list_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("list")

    list = @list_digestor.from_xml_string(xml_response)
    list.id.should == 3202
    list.key.should == "featured_albums"
    list.list_items.size.should == 2
    list.list_items[0].release.id.should == 1879539
    list.list_items[1].release.id.should == 1879543
  end

end