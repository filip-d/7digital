require File.expand_path('../../spec_helper', __FILE__)

describe "OAuthAccessTokenDigestor" do

  before do
    @stub_oauth_consumer = stub(OAuth::Consumer)
    api_client = stub(Sevendigital::Client)
    api_client.stub!(:oauth_consumer).and_return(@stub_oauth_consumer)
    @token_digestor = Sevendigital::OAuthAccessTokenDigestor.new(api_client)
  end


    it "should not digest from invalid xml but throw up (exception)" do

    xml_response = <<XML
    <release id="123">
      <name>expected artist name</name>
    </release>
XML

    running {@token_digestor.from_xml_nokogiri(xml_response)}.should raise_error(Sevendigital::DigestiveProblem)
    end
  
  it "should digest access token xml and populate all properties" do

    xml_response = load_sample_object_xml("oauth_access_token")

    token = @token_digestor.from_xml_nokogiri(xml_response, :oauth_access_token)
    token.kind_of?(OAuth::AccessToken).should == true
    token.token.should == "E3w4FV3oirRfj4KfT7alOpa893mmn4HJ"
    token.secret.should == "923kj3Kspa304n4Oamd3201pLkgjeM32"
    token.consumer.should == @stub_oauth_consumer
  end

end