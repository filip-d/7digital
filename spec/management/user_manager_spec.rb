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

end