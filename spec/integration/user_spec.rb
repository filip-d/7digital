# encoding: UTF-8
require File.expand_path('../../spec_helper', __FILE__)
require 'date'

describe "User integration tests" do

  before do
    @api_client = Sevendigital::Client.new(
          File.join(File.dirname(__FILE__),"sevendigital_spec.yml"),
          :verbose => "verbose"
    )

  end

  it "should fail to sign up an existing user" do
    running {user = @api_client.user.sign_up("filip@7digital.com", "£$%^&*()_+")}.should raise_error(Sevendigital::SevendigitalError) { |error|
      error.error_message.should == "User with given email already exists"
      error.error_code.should == 2003
    }
  end

end
