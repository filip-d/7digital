require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "OAuthRequestTokenDigestor" do

  before do
     @token_digestor = Sevendigital::OAuthTokenDigestor.new(nil)
  end


    it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@token_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
    end
  
  it "should digest request token xml and populate all properties" do

    xml_response = load_sample_object_xml("oauth_request_token")

    token = @token_digestor.from_xml(xml_response, :oauth_request_token)
    token.token.should == "yu87230J29DT7tyuGslO98wrR43e39Of"
    token.secret.should == "d2I8uj7yaoa39KKdu3upasybu98f89fln"
  end

  it "should digest access token xml and populate all properties" do

    xml_response = load_sample_object_xml("oauth_access_token")

    token = @token_digestor.from_xml(xml_response, :oauth_access_token)
    token.token.should == "E3w4FV3oirRfj4KfT7alOpa893mmn4HJ"
    token.secret.should == "923kj3Kspa304n4Oamd3201pLkgjeM32"
  end

end