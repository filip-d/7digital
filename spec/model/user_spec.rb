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

end