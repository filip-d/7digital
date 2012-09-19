# coding: utf-8
require File.expand_path('../../spec_helper', __FILE__)

describe "CountryDigestor" do

  before do
     @country_digestor = Sevendigital::CountryDigestor.new(nil)
  end

   it "should not digest from invalid xml but throw up (exception)" do

     xml_response = <<XML
     <xxx>
       <text>pop</text>
     </xxx>
XML

    running {@country_digestor.from_xml_string(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
  end

  it "should parse from xml and return country code" do

    xml_response = <<XML
<GeoIpLookup>
  <countryCode>SK</countryCode>
</GeoIpLookup>
XML

    @country_digestor.from_xml_string(xml_response, 'GeoIpLookup').should == 'SK'
    
  end

end
