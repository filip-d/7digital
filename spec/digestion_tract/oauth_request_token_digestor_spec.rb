require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "OAuthRequestTokenDigestor" do

  before do
    @stub_oauth_consumer = stub(OAuth::Consumer)
    api_client = stub(Sevendigital::Client)
    api_client.stub!(:oauth_consumer).and_return(@stub_oauth_consumer)
    @token_digestor = Sevendigital::OAuthRequestTokenDigestor.new(api_client)
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
    token.kind_of?(OAuth::RequestToken).should == true
    token.token.should == "yu87230J29DT7tyuGslO98wrR43e39Of"
    token.secret.should == "d2I8uj7yaoa39KKdu3upasybu98f89fln"
    token.consumer.should == @stub_oauth_consumer
  end

end