require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "UserManager" do

  before do
    @client = stub(Sevendigital::Client)
    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @user_manager = Sevendigital::UserManager.new(@client)
  end

  it "authenticate should return an authenticated user if supplied with valid login details" do
    user = @user_manager.authenticate("email", "password")
    user.kind_of?(Sevendigital::User).should == true
    user.authenticated.should == true
  end

  it "authenticate should return nil if user does not authenticate" do
    user = @user_manager.authenticate("email", "password")
    user.nil?.should == true
    
  end

  it "get_oauth_request_token should call oauth/requestToken api method and digest the request_token from response" do

    fake_token = OAuth::RequestToken.new("aaa", "bbb", "ccc")
    api_response = fake_api_response("oauth/requesttoken")

    mock_client_digestor(@client, :request_token_digestor) \
      .should_receive(:from_xml).with(api_response.content.oauth_request_token).and_return(fake_token)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "oauth/requestToken"
       api_request.signed.should == true
       api_response
    }

    token = @user_manager.get_oauth_request_token
    token.should == fake_token

  end


end