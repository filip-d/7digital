require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "OAuthRequestTokenDigestor" do

  before do
     @token_digestor = Sevendigital::OAuthRequestTokenDigestor.new(nil)
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
  end

end