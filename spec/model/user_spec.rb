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

  it "should raise Sevendigital::Error if user is not authenticated" do
    expected_options = {:page => 2}

    running {@user.get_locker}.should raise_error(Sevendigital::SevendigitalError)


  end

end