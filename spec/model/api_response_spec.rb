require "spec"
require 'sevendigital'

describe "ApiResponse" do

  it "should be ok if error code is 0 and content is not empty" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.content = '<xml></xml>'
    response.is_ok?.should == true

  end

  it "should not be ok if error code is not 0" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 5
    response.content = '<xml></xml>'
    response.is_ok?.should == false

    end

  it "should not be ok if response content is nil" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.is_ok?.should == false

  end

end