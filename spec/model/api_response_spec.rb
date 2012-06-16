require File.expand_path('../../spec_helper', __FILE__)
require 'time'

describe "ApiResponse" do

  it "should be ok if error code is 0 and content is not empty" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.content = '<xml></xml>'
    response.ok?.should == true

  end

  it "should not be ok if error code is not 0" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 5
    response.content = '<xml></xml>'
    response.ok?.should == false

    end

  it "should not be ok if response content is nil" do

    response = Sevendigital::ApiResponse.new
    response.error_code = 0
    response.ok?.should == false

  end

  it "should be serializable" do
    original_response = Sevendigital::ApiResponse.new
    original_response.content = "<response status='ok'><testElement id='123'>value</testElement></response>"
    original_response.error_code = 99
    original_response.headers = {"header" => "value"}


    tmp = Marshal.dump(original_response)
    restored_response = Marshal.load(tmp)

    restored_response.error_code.should == original_response.error_code
    restored_response.content.to_s.should == original_response.content.to_s
    restored_response.item_xml("response").to_s == "value"
    restored_response.headers.should == original_response.headers

  end

end