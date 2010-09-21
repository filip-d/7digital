require "spec"
require File.join(File.dirname(__FILE__), %w[spec_helper])
require 'ostruct'

describe "ApiOperator" do

  before do
    response_digestor = stub(Sevendigital::ApiResponseDigestor)
    response_digestor.stub!(:from_http_response). and_return(fake_digested_response)

    stub_api_client(test_configuration, response_digestor)

    Net::HTTP.stub!(:get_response).and_return(fake_api_response)

    @api_operator = Sevendigital::ApiOperator.new(@client)

    @stub_api_request = stub_api_request()

  end

  it "should create request URI based on api method and client configuration" do

    api_request = Sevendigital::ApiRequest.new("api/method", {:param1 => "value", :paramTwo => 2})

    uri = @api_operator.create_request_uri(api_request)

    uri.kind_of?(URI).should == true

    uri.to_s.should =~ /http:\/\/base.api.url\/version\/api\/method\?oauth_consumer_key=oauth_consumer_key/
    uri.to_s.should =~ /\&param1=value/
    uri.to_s.should =~ /\&paramTwo=2/

  end

  it "should make sure country is set before making request" do
    @client.stub!(:country).and_return("sk")

    @stub_api_request.should_receive(:ensure_country_is_set).with("sk")
    
    @api_operator.call_api(@stub_api_request)

  end

  it "should make HTTP request and get response" do

    Net::HTTP.should_receive(:get_response).with(@api_operator.create_request_uri(@stub_api_request))

    @api_operator.call_api(@stub_api_request)

  end

  it "should digest the HTTP response and get it out" do

    http_response = fake_api_response
    digested_response = fake_digested_response

    Net::HTTP.stub!(:get_response).and_return(http_response)

    @client.api_response_digestor.should_receive(:from_http_response).with(http_response).and_return(digested_response)

    response = @api_operator.call_api(@stub_api_request)

    response.should == digested_response

  end

  it "should throw an exception if response is not ok" do

    Net::HTTP.stub(:get_response).and_return(fake_api_response)
    failed_response = fake_digested_response(false)
    failed_response.stub!(:error_code).and_return("4000")
    failed_response.stub!(:error_message).and_return("error")
      @client.api_response_digestor.stub!(:from_http_response).and_return(failed_response)

    running { @api_operator.call_api(@stub_api_request) }.should raise_error(Sevendigital::SevendigitalError)

  end

  def test_configuration
    configuration = OpenStruct.new
    configuration.api_url = "base.api.url"
    configuration.api_version = "version"
    configuration.oauth_consumer_key = "oauth_consumer_key"
    return configuration
  end

  def fake_api_response(code = 200, body = "response_body")
    return Net::HTTP.new("1.1", code, body)
  end

  def fake_digested_response(is_ok = true)
    proxy =  stub(Peachy::Proxy)#.new('<response status="ok"><content>test</content></response>')
    proxy.stub!(:ok?).and_return(is_ok)
    proxy
  end

  def stub_api_client(configuration, response_digestor)
  @client = stub(Sevendigital::Client)
  @client.stub!(:configuration).and_return(configuration)
  @client.stub!(:api_response_digestor).and_return(response_digestor)
  @client.stub!(:country).and_return("sk")
  @client.stub!(:verbose?).and_return(false)
  @client.stub!(:very_verbose?).and_return(false)

end

def stub_api_request
  api_request = stub(Sevendigital::ApiRequest)

  api_request.stub!(:parameters).and_return({})
  api_request.stub!(:api_method).and_return("m")
  api_request.stub!(:ensure_country_is_set)
  return api_request
end

end