require 'spec'
require File.join(File.dirname(__FILE__), %w[../spec_helper])


describe "ApiResponseDigestor" do

  before do
    @api_response_digestor = Sevendigital::ApiResponseDigestor.new(nil)
  end

  it "should create a response with body from http ok response" do

    stub_http_response = stub(Net::HTTPSuccess)
    stub_http_response.stub!(:is_a?).with(Net::HTTPSuccess).and_return(true)
    stub_http_response.stub!(:body).and_return('<response status="ok"></response>')

    response =  @api_response_digestor.from_http_response(stub_http_response)
    response.error_code.should == 0
  end

  it "should create an error response from http non-ok response" do
    expected_message = 'Authorisation failed'
    expected_error_code = 401

    stub_http_response = stub(Net::HTTPSuccess)
    stub_http_response.stub!(:is_a?).with(Net::HTTPSuccess).and_return(false)
    stub_http_response.stub!(:code).and_return(expected_error_code.to_s)
    stub_http_response.stub!(:body).and_return(expected_message)

    response =  @api_response_digestor.from_http_response(stub_http_response)
    response.error_code.should == 401
    response.error_message.should == expected_message

  end



  it "should create a response with body from xml ok response" do

    xml_response = <<XML
    <response status="ok"><test></test></response>
XML
    response = @api_response_digestor.from_xml(xml_response)
    response.error_code.should == 0
    response.content.test.should_not == nil
    response.content.nothing.should == nil
  end


  it "should create a response with error details from xml error response" do

    xml_response = '<response status="error"><error code="1000"><errorMessage>expected error message</errorMessage></error></response>'
    response = @api_response_digestor.from_xml(xml_response)
    response.error_code.should == 1000
    response.error_message.should == 'expected error message'
  end

  it "should create a response with error details from invalid xml response" do

    xml_response = '<wrongresponse status="ok"><test /></wrongresponse>'
    response = @api_response_digestor.from_xml(xml_response)
    response.error_code.should == 10000
    response.error_message.should == 'Invalid 7digital API response'
  end

    it "should create a response with error details from valid xml response with invalid status" do

    xml_response = '<response status="unkown"><test></test></response>'
    response = @api_response_digestor.from_xml(xml_response)
    response.error_code.should == 10000
    response.error_message.should == 'Invalid 7digital API response'
  end

end
