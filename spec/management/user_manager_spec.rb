require File.expand_path('../../spec_helper', __FILE__)

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

    @client.should_receive(:make_signed_api_request) \
        .with("user/locker", {}, {}, a_token) \
        .and_return(an_api_response)
    
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

    @client.should_receive(:make_signed_api_request) \
           .with("user/purchase/item", \
                {:trackId => a_track_id, :releaseId => a_release_id, :price => a_price}, \
                {}, a_token) \
           .and_return(an_api_response)

    @user_manager.purchase(a_release_id, a_track_id, a_price, a_token).should == fake_locker

  end

  it "should get stream track URI" do
    a_stream_track_uri = "http://media.com/streamtrack"
    a_track_id = 123456
    a_release_id = 78910
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    an_api_request = stub(Sevendigital::ApiRequest)

    @client.should_receive(:create_api_request) \
      .with("user/streamtrack", {:trackId => a_track_id, :releaseId => a_release_id}, {}) \
      .and_return(an_api_request)

    an_api_request.should_receive(:api_service=).with(:media)
    an_api_request.should_receive(:require_signature)
    an_api_request.should_not_receive(:require_secure_connection)
    an_api_request.should_receive(:token=).with(a_token)

    @client.operator.should_receive(:get_request_uri) \
      .with(an_api_request) \
      .and_return(a_stream_track_uri)

    @user_manager.get_stream_track_url(a_release_id, a_track_id, a_token).should == a_stream_track_uri

  end

  it "should get add card URI" do
    an_add_card_uri = "http://account.com/addcard"
    a_token = OAuth::AccessToken.new(nil, "token", "token_secret")
    a_return_url = "http://example.com/"
     an_api_request = stub(Sevendigital::ApiRequest)

    @client.should_receive(:create_api_request) \
      .with("payment/addcard", {:returnUrl => a_return_url}, {}) \
      .and_return(an_api_request)

    an_api_request.should_receive(:api_service=).with(:account)
    an_api_request.should_receive(:require_signature)
    an_api_request.should_receive(:require_secure_connection)
    an_api_request.should_receive(:token=).with(a_token)

    @client.operator.should_receive(:get_request_uri) \
      .with(an_api_request) \
      .and_return(an_add_card_uri)

    @user_manager.get_add_card_url(a_return_url, a_token).should == an_add_card_uri

  end


end