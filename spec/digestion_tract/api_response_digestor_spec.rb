require File.expand_path('../../spec_helper', __FILE__)

describe "ApiResponseDigestor" do

  before do
    @api_response_digestor = Sevendigital::ApiResponseDigestor.new(nil)
  end

  it "should create a response with body from http ok response" do
    body = '<response status="ok"></response>'

    stub_http_response = stub_ok_http_response(body)

    response =  @api_response_digestor.from_http_response(stub_http_response)
    response.error_code.should == 0
    response.content.should == body
  end

  it "should create an error response from http non-ok response" do
    expected_message = 'Authorisation failed'
    expected_error_code = 401

    stub_http_response = stub(Net::HTTPSuccess)
    stub_http_response.stub!(:is_a?).with(Net::HTTPSuccess).and_return(false)
    stub_http_response.stub!(:code).and_return(expected_error_code.to_s)
    stub_http_response.stub!(:body).and_return(expected_message)
    stub_http_response.stub!(:header).and_return(nil)

    response =  @api_response_digestor.from_http_response(stub_http_response)
    response.error_code.should == 401
    response.error_message.should == expected_message

  end


  it "should store headers from http response" do

    stub_http_response = stub_ok_http_response('<response status="ok"></response>')
    stub_http_response.stub!(:header).and_return({"cache-control" => "test", "date" => "now"})

    response =  @api_response_digestor.from_http_response(stub_http_response)
    response.headers["cache-control"].should == "test"
    response.headers["date"].should == "now"
  end


  it "should create a response with body from xml ok response" do
    xml_response = stub_ok_http_response("<response status=\"ok\">body</response>")
    response = @api_response_digestor.from_http_response(xml_response)
    response.error_code.should == 0
  end


  it "should create a response with error details from xml error response" do

    xml_response = stub_ok_http_response(
        '<response status="error"><error code="1000"><errorMessage>expected error message</errorMessage></error></response>')
    response = @api_response_digestor.from_http_response(xml_response)
    response.error_code.should == 1000
    response.error_message.should == 'expected error message'
  end

  it "should create a response with error details from invalid xml response" do

    xml_response = stub_ok_http_response('<wrongresponse status="ok"><test /></wrongresponse>')
    response = @api_response_digestor.from_http_response(xml_response)
    response.error_code.should == 10001
    response.error_message.should == 'Invalid 7digital API response'

    xml_response = stub_ok_http_response('<response><test /></response>')
    response = @api_response_digestor.from_http_response(xml_response)
    response.error_code.should == 10001
    response.error_message.should == 'Invalid 7digital API response'
  end


    it "should create a response with error details from valid xml response with invalid status" do

    xml_response = stub_ok_http_response('<response status="unkown"><test></test></response>')
    response = @api_response_digestor.from_http_response(xml_response)
    response.error_code.should == 10001
    response.error_message.should == 'Invalid 7digital API response'
    end

  def stub_ok_http_response(body)
    stub_http_response = stub(Net::HTTPSuccess)
    stub_http_response.stub!(:is_a?).with(Net::HTTPSuccess).and_return(true)
    stub_http_response.stub!(:body).and_return(body)
    stub_http_response.stub!(:header).and_return(nil)
    stub_http_response
  end

end
