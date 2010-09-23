require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "OAuthManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @oauth_manager = Sevendigital::OAuthManager.new(@client)
  end

  it "get_oauth_request_token should call oauth/requestToken api method and digest the request_token from response" do

    fake_token = OAuth::RequestToken.new("aaa", "bbb", "ccc")
    api_response = fake_api_response("oauth/requesttoken")

    digestor = mock(Sevendigital::OAuthTokenDigestor)
    @client.stub!(:oauth_request_token_digestor).and_return(digestor)
    
    digestor.should_receive(:from_xml).with(api_response.content.oauth_request_token, :oauth_request_token).and_return(fake_token)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "oauth/requestToken"
       api_request.signed.should == true
       api_response
    }

    token = @oauth_manager.get_request_token
    token.should == fake_token

  end

    it "get_oauth_access_token should call oauth/accessToken api method and digest the access_token from response" do

    a_request_token = OAuth::RequestToken.new("aaa", "bbb", "ccc")
    fake_token = OAuth::RequestToken.new("aaa", "bbb", "ccc")
    api_response = fake_api_response("oauth/requesttoken")

    digestor = mock(Sevendigital::OAuthTokenDigestor)
    @client.stub!(:oauth_request_token_digestor).and_return(digestor)

    digestor.should_receive(:from_xml).with(api_response.content.oauth_request_token, :oauth_access_token).and_return(fake_token)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "oauth/requestToken"
       api_request.token.should == a_request_token
       api_request.signed.should == true
       api_response
    }

    token = @oauth_manager.get_access_token(a_request_token)
    token.should == fake_token

  end


end