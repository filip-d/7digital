# coding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe "UserDigestor" do

  before do
     @user_digestor = Sevendigital::UserDigestor.new(nil)
  end

   it "should not digest from invalid xml but throw up (exception)" do

     xml_response = <<XML
     <xxx>
       <type>invalid</type>
     </xxx>
XML

    running {@user_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate minimum available properties" do

    xml_response = <<XML
<user>
  <type>7digital</type>
</user>
XML

    user = @user_digestor.from_xml(xml_response)
    user.type.should == :"7digital"
    
  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("user")

    user = @user_digestor.from_xml(xml_response)
    user.id.should == "123456"
    user.type.should == :"7digital"
    user.email_address.should == "user@example.com"
  end

end
