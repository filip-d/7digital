require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "OAuthAccessTokenDigestor" do

  before do
     @token_digestor = Sevendigital::OAuthAccessTokenDigestor.new(nil)
  end


    it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@token_digestor.from_xml(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
    end
  
  it "should digest access token xml and populate all properties" do

    xml_response = load_sample_object_xml("oauth_access_token")

    token = @token_digestor.from_xml(xml_response, :oauth_access_token)
    token.kind_of?(OAuth::AccessToken).should == true
    token.token.should == "E3w4FV3oirRfj4KfT7alOpa893mmn4HJ"
    token.secret.should == "923kj3Kspa304n4Oamd3201pLkgjeM32"
  end

end