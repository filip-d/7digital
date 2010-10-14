require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "UserManager" do

  before do

    @an_email = "email"
    @a_password = "password"
    @a_request_token = fake_request_token
    @an_access_token = fake_access_token

    @client = stub(Sevendigital::Client)

    @oauth_manager = mock(Sevendigital::OAuthManager)
    @oauth_manager.stub!(:get_request_token).and_return(@a_request_token)
    @oauth_manager.stub!(:authorise_request_token).and_return(true)
    @oauth_manager.stub!(:get_access_token).and_return(@an_access_token)

    @client.stub!(:operator).and_return(mock(Sevendigital::ApiOperator))
    @client.stub!(:oauth).and_return(@oauth_manager )
    @user_manager = Sevendigital::UserManager.new(@client)
  end

  it "should log in user using an existing access token" do
    an_access_token = OAuth::AccessToken.new("aaa", "bbb", nil)
    @user = @user_manager.login(an_access_token)
    @user.authenticated?.should == true
  end

  it "should not log in user using an request token but raise an exception" do
    a_request_token = OAuth::RequestToken.new("aaa", "bbb", nil)
    running {@user = @user_manager.login(a_request_token)}.should raise_exception Sevendigital::SevendigitalError
    @user.nil?.should == true
  end

  it "authenticate should return an authenticated user if supplied with valid login details" do
    user = @user_manager.authenticate("email", "password")
    user.kind_of?(Sevendigital::User).should == true
    user.authenticated?.should == true
  end

  it "authenticate should return nil if user does not authenticate" do
    @oauth_manager.stub!(:authorise_request_token).and_return(false)
    user = @user_manager.authenticate("email", "password")
    user.nil?.should == true
  end

  it "authenticate should get a request token" do
    @client.oauth.should_receive(:get_request_token).and_return(nil)
    @user_manager.authenticate("email", "password")
  end

  it "authenticate should attempt to authorise request token" do
    @client.oauth.should_receive(:authorise_request_token).with(@an_email, @a_password, @a_request_token) \
      .and_return(true)
    @user_manager.authenticate(@an_email, @a_password)
  end

  it "authenticate should retrieve access_token for authenticated user" do
    @client.oauth.should_receive(:get_access_token).with(@a_request_token) \
      .and_return(@an_access_token)
    user = @user_manager.authenticate(@an_email, @a_password)
    user.oauth_access_token.should == @an_access_token
  end

  def fake_request_token
    token = stub(OAuth::RequestToken)
    token.stub(:token).and_return("key")
    token
  end

  def fake_access_token
    token = stub(OAuth::RequestToken)
    token.stub(:token).and_return("key")
    token
  end

  it "get_locker should call user/locker api method and return digested locker" do
    an_api_response = fake_api_response("user/locker")
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    fake_locker = [Sevendigital::LockerRelease.new(@client)]

    mock_client_digestor(@client, :locker_digestor) \
      .should_receive(:from_xml).with(an_api_response.content.locker).and_return(fake_locker)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "user/locker"
       api_request.token.should  == a_token
       an_api_response
    }

    @user_manager.get_locker(a_token).should == fake_locker

  end

  it "purchase should call user/purchase/item api method and return digested locker items" do
    an_api_response = fake_api_response("user/purchase/item")
    a_track_id = 123456
    a_release_id = 56879
    a_price = 0.99
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    fake_locker = [Sevendigital::LockerRelease.new(@client)]

    mock_client_digestor(@client, :locker_digestor) \
      .should_receive(:from_xml).with(an_api_response.content.purchase).and_return(fake_locker)

    @client.operator.should_receive(:call_api) { |api_request|
       api_request.api_method.should == "user/purchase/item"
       api_request.parameters[:trackId].should  == a_track_id
       api_request.parameters[:releaseId].should  == a_release_id
       api_request.parameters[:price].should  == a_price
       api_request.token.should  == a_token
       an_api_response
    }

    @user_manager.purchase(a_release_id, a_track_id, a_price, a_token).should == fake_locker

  end

  it "should get stream track URI" do
    a_stream_track_uri = "http://media.com/streamtrack"
    a_track_id = 123456
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")

    @client.operator.should_receive(:get_request_uri) { |api_request|
       api_request.api_method.should == "user/streamtrack"
       api_request.parameters[:trackId].should  == a_track_id
       api_request.token.should  == a_token
       a_stream_track_uri
    }

    @user_manager.get_stream_track_url(a_track_id, a_token).should == a_stream_track_uri

  end


end