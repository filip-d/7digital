# coding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe "TagDigestor" do

  before do
     @tag_digestor = Sevendigital::TagDigestor.new(nil)
  end

   it "should not digest from invalid xml but throw up (exception)" do

     xml_response = <<XML
     <xxx>
       <text>pop</text>
     </xxx>
XML

    running {@tag_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate minimum available properties" do

    xml_response = <<XML
<tag id="rock">
  <text>ROCK</text>
</tag>
XML

    tag = @tag_digestor.from_xml(xml_response)
    tag.id.should == 'rock'
    tag.text.should == "ROCK"
    
  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("tag")

    tag = @tag_digestor.from_xml(xml_response)
    tag.id.should == "pop"
    tag.text.should == "pop"
    tag.url.should == "http://www.7digital.com/tags/pop?partner=123"
    tag.count.should == 90847
  end

end
