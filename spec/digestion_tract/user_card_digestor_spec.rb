# coding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe "UserCardDigestor" do

  before do
     @card_digestor = Sevendigital::UserCardDigestor.new(nil)
  end

   it "should not digest from invalid xml but throw up (exception)" do

     xml_response = <<XML
     <xxx>
       <type>invalid</type>
     </xxx>
XML

    running {@card_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and populate minimum available properties" do

    xml_response = <<XML
<card>
  <type>MasterCard</type>
  <last4digits>1234</last4digits>
</card>
XML

    card = @card_digestor.from_xml(xml_response)
    card.type.should == "MasterCard"
    card.last_4_digits.should == "1234"

  end

  it "should parse from xml and populate all properties" do

    xml_response = load_sample_object_xml("user_payment_card")

    card = @card_digestor.from_xml(xml_response)
    card.type.should == "VISA"
    card.last_4_digits.should == "2345"
    card.expiry_date.should == "201109"
    card.card_holder_name.should == "Mr. John Smith"

  end

end
