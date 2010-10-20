require "date"
require File.join(File.dirname(__FILE__), %w[../spec_helper])

describe "User" do

  before do
    @client = stub(Sevendigital::Client)
    @user_manager = mock(Sevendigital::UserManager)
    @client.stub!(:user).and_return @user_manager
    
    @user = Sevendigital::User.new(@client)
  end

  it "should not be authorised if does not have access_token" do
    @user.oauth_access_token = nil
    @user.authenticated?.should == false
  end

  it "should be authorised if does have access_token" do
    @user.oauth_access_token = "something"
    @user.authenticated?.should == true
  end

  it "should get user's locker from locker manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    fake_locker = [Sevendigital::LockerRelease.new(@client)]
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_locker) { |token, options|
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_locker
    }
    locker = @user.get_locker(expected_options)
    locker.should == fake_locker
  end

  it "should get user manager to make a purchase" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_release_id = 123
    a_track_id = 456
    a_price = 1.29
    fake_locker = [Sevendigital::LockerRelease.new(@client)]
    expected_options = {:page => 2}

    @user_manager.should_receive(:purchase) { |release_id, track_id, price, token, options|
      token.should == @user.oauth_access_token
      release_id.should == a_release_id
      track_id.should == a_track_id
      price.should == a_price
      (options.keys & expected_options.keys).should == expected_options.keys
      fake_locker
    }
    purchase_locker = @user.purchase!(a_release_id, a_track_id, a_price, expected_options)
    purchase_locker.should == fake_locker
  end

  it "should get stream track url from user manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_track_id = 456
    a_release_id = 123
    a_stream_track_url = "http://whatever"
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_stream_track_url) { |release_id, track_id, token, options|
      token.should == @user.oauth_access_token
      track_id.should == a_track_id
      release_id.should == a_release_id
      (options.keys & expected_options.keys).should == expected_options.keys
      a_stream_track_url
    }
    @user.stream_track_url(a_release_id, a_track_id, expected_options).should == a_stream_track_url
  end

  it "should not get a stream tack url but raise Sevendigital::Error if user is not authenticated" do
    running {@user.get_locker}.should raise_error(Sevendigital::SevendigitalError)
  end

  it "should get an add card url from user manager" do
    @user.oauth_access_token = OAuth::AccessToken.new(nil, "TOKEN", "SECRET")
    a_stream_track_url = "http://whatever"
    a_return_url = "http://example.com"
    expected_options = {:page => 2}

    @user_manager.should_receive(:get_add_card_url) { |return_url, token, options|
      return_url.should == a_return_url
      token.should == @user.oauth_access_token
      (options.keys & expected_options.keys).should == expected_options.keys
      a_stream_track_url
    }
    @user.add_card_url(a_return_url, expected_options).should == a_stream_track_url
  end

  it "should not get a stream tack url but raise Sevendigital::Error if user is not authenticated" do
    running {@user.get_locker}.should raise_error(Sevendigital::SevendigitalError)
  end

end